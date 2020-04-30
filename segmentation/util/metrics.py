import torch
import numpy as np
import torch.nn.functional as F
from sklearn.metrics.pairwise import pairwise_distances

# DICE LOSS
# Only used to understand what stage we are at, as a direct measure of the
# quality of the training output. We are not optimizing for this!
def dice_coeff(pred, target):
    """
    :param output: NxCxDxHxW Variable
    :param target: NxDxHxW LongTensor
    :return:
    """
    eps = 0.0001
    encoded_target = pred.detach() * 0
    encoded_target.scatter_(1, target.unsqueeze(1), 1)

    intersection = pred * encoded_target
    numerator = 2 * torch.squeeze(intersection).sum(1).sum(1).sum(1)
    denominator = pred + encoded_target

    denominator = torch.squeeze(denominator).sum(1).sum(1).sum(1) + eps
    loss_per_channel =  (1 - (numerator / denominator))

    return loss_per_channel.sum() / loss_per_channel.size(0)

def hausdorff_distance(set1, set2, max_ahd=np.inf):
    if len(set1) == 0 or len(set2) == 0:
        return max_ahd

    set1 = np.array(set1)
    set2 = np.array(set2)

    assert set1.ndim == set2.ndim

    d2_matrix = pairwise_distances(set1, set2, metric='euclidean')
    directed = [np.min(d2_matrix, axis = i) for i in [0, 1]]
    avg_ = (directed[0].mean() + directed[1].mean()) / 2.0
    max_ = max(directed[0].max(), directed[1].max())

    return {'average': avg_, 'maximum': max_}

def MSE(segmentation, ground_truth_segmentation):
    return np.square(segmentation - ground_truth_segmentation).reshape(segmentation.shape[0], -1).mean(axis = 1)

def tip_distance(pts_a,pts_b):
    dist = np.sqrt((pts_b[len(pts_b)-1,0] - pts_a[len(pts_a)-1,0])**2 + (pts_b[len(pts_b)-1,1] - pts_a[len(pts_a)-1,1])**2)
    return dist

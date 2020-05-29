import torch
import torchvision
from torch.utils.data import Dataset, DataLoader
import numpy as np

# implement Simulation of Dataset
class SimDataset(Dataset):
	def __init__(self, _simulated, _ground_truth, _spline_pts, transform=None):
		self.input_images, self.target_masks, self.spline_pts = np.array(_simulated), np.array(_ground_truth), np.array(_spline_pts)
		self.transform = transform

	def __len__(self):
		return len(self.input_images)

	def __getitem__(self, idx):
		image = self.input_images[idx]
		mask = self.target_masks[idx]
		pts = self.spline_pts[idx]

		if self.transform:
			image = self.transform(image)

		return [image, mask, pts]

def gen_dataloaders(X_train, X_test, pts_train, y_train, y_test, pts_test, batch_size):
	trans = torchvision.transforms.Compose([
		torchvision.transforms.ToTensor(),
	])

	# Create a train set and a validation set, each with input images (simulation data) and target masks (ground truth data)
	train_set = SimDataset(X_train, y_train, pts_train, transform = trans)
	val_set = SimDataset(X_test, y_test, pts_test, transform = trans)

	image_datasets = {
		'train': train_set, 'val': val_set
	}

	dataloaders = {
		'train': DataLoader(train_set, batch_size=batch_size, shuffle=True, num_workers=0),
		'val': DataLoader(val_set, batch_size=batch_size, shuffle=True, num_workers=0)
	}

	dataset_sizes = {
		x: len(image_datasets[x]) for x in image_datasets.keys()
	}

	print(dataset_sizes)
	return dataloaders

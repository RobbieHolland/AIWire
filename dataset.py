import torch
import torchvision
from torch.utils.data import Dataset, DataLoader
from sklearn.model_selection import train_test_split
import numpy as np

# implement Simulation of Dataset
class SimDataset(Dataset):
    def __init__(self, _simulated, _ground_truth, transform=None):
        self.input_images, self.target_masks = np.array(_simulated), np.array(_ground_truth)
        self.transform = transform

    def __len__(self):
        return len(self.input_images)

    def __getitem__(self, idx):
        image = self.input_images[idx]
        mask = self.target_masks[idx]
        if self.transform:
            image = self.transform(image)

        return [image, mask]

def gen_dataloaders(X, y, batch_size, test_prop):
    trans = torchvision.transforms.Compose([
        torchvision.transforms.ToTensor(),
    ])

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=test_prop)

    # Create a train set and a validation set, each with input images (simulation data) and target masks (ground truth data)
    train_set = SimDataset(X_train, y_train, transform = trans)
    val_set = SimDataset(X_test, y_test, transform = trans)

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

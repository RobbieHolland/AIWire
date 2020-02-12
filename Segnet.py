import torch
import torch.nn as nn
import torch.nn.functional as F

# Using eric's segnet

class SegNet(nn.Module):


    def __init__(self, num_class):
        super().__init__()

        self.model = nn.Sequential(
            # layer 1
            nn.Conv2d(num_class, 4, 3, 2, 1),
            nn.InstanceNorm2d(4),
            nn.PReLU(),
            # layer 2
            nn.Conv2d(4, 8, 3, 2, 1),
            nn.InstanceNorm2d(8),
            nn.PReLU(),
            nn.Dropout2d(),
            # layer 3
            nn.Conv2d(8, 16, 3, 2, 1),
            nn.InstanceNorm2d(16),
            nn.PReLU(),
            # bottom layer
            nn.Conv2d(16, 16, 3, 1, 1),
            nn.Dropout2d(),
            # layer 5
            nn.ConvTranspose2d(16, 8, 3, 2, 1, 1),
            nn.InstanceNorm2d(8),
            nn.PReLU(),
            # layer 6
            nn.ConvTranspose2d(8, 4, 3, 2, 1, 1),
            nn.InstanceNorm2d(4),
            nn.PReLU(),
            nn.Dropout2d(),
            # layer 7
            nn.ConvTranspose2d(4, 2, 3, 2, 1, 1),
            nn.InstanceNorm2d(2),
            nn.PReLU(),
            # layer 8: output
            nn.Conv2d(2, num_class, 3, 1, 1),
        )

    def forward(self, x):
        return self.model(x)
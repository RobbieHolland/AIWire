import torch
import torch.nn as nn
import torch.nn.functional as F



class SegNet(nn.Module):

    def __init__(self, num_class):
        super().__init__()

        self.model = nn.Sequential(
            # layer 1
            nn.Conv2d(num_class, 4, 3, 2, 1),
            nn.BatchNorm2d(4),
            nn.ReLU(),
            # layer 2
            nn.Conv2d(4, 8, 3, 2, 1),
            nn.BatchNorm2d(8),
            nn.ReLU(),
            # layer 3
            nn.Conv2d(8, 16, 3, 2, 1),
            nn.BatchNorm2d(16),
            nn.ReLU(),
            # nn.Dropout2d(),
            # layer 4
            nn.Conv2d(16, 32, 3, 2, 1),
            nn.BatchNorm2d(32),
            nn.ReLU(),
            # layer 5
            nn.Conv2d(32, 64, 3, 2, 1),
            nn.BatchNorm2d(64),
            nn.ReLU(),
            # bottom layer
            nn.Conv2d(64, 64, 3, 1, 1),
            # nn.Dropout2d(),
            # layer 6
            nn.ConvTranspose2d(64, 32, 3, 2, 1, 1),
            nn.BatchNorm2d(32),
            nn.ReLU(),
            # layer 7
            nn.ConvTranspose2d(32, 16, 3, 2, 1, 1),
            nn.BatchNorm2d(16),
            nn.ReLU(),
            # nn.Dropout2d(),
            # layer 8
            nn.ConvTranspose2d(16, 8, 3, 2, 1, 1),
            nn.BatchNorm2d(8),
            nn.ReLU(),
            # layer 9
            nn.ConvTranspose2d(8, 4, 3, 2, 1, 1),
            nn.BatchNorm2d(4),
            nn.ReLU(),
            # layer 10
            nn.ConvTranspose2d(4, 2, 3, 2, 1, 1),
            nn.BatchNorm2d(2),
            nn.ReLU(),
            # layer 11: output
            nn.Conv2d(2, num_class, 3, 1, 1),
        )

        


    def forward(self, x):
        x1 =self.model(x)
        out = nn.Sigmoid()(x1)
        return out
# Model files

After training, this folder should contain:

- `emotionNet.mat` with variable `emotionNet`, labels Happy, Sad, Neutral
- `maskNet.mat` with variable `maskNet`, labels Mask, No Mask

The repository intentionally does not contain fake or untrained model files. Use `trainVisionModels.m` with your properly labelled dataset to create these files. Check licenses before distributing trained weights.

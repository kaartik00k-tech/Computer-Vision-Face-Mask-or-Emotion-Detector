# Training data layout

Place appropriately licensed, labelled, face-cropped images into this structure. Do not commit personal/sensitive images to a public repository.

```
dataset/
  emotion/
    Happy/
    Sad/
    Neutral/
  mask/
    Mask/
    No Mask/
```

Use enough diverse examples for every class, including varied lighting, camera angles, skin tones, ages, and occlusion where appropriate. Use a subject-disjoint held-out test set for final evaluation. Do not train and evaluate on near-duplicate images or frames of the same person across splits. Confirm each dataset's license, consent, and usage restrictions.

Run `trainVisionModels` from MATLAB after placing the data. The script uses a small CNN trained from scratch; performance is not guaranteed. Model output depends heavily on dataset quality and should not be used for consequential decisions.

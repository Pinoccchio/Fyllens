# Gemini API Models Reference - Working with v1beta

## ✅ CONFIRMED WORKING MODEL
**Current Implementation:** `gemini-pro-latest`

This is a **stable alias** that always points to the latest pro model version and is confirmed to work with the google_generative_ai package v0.4.6 and v1beta API.

---

## Available Models (Verified from API)

### Recommended: Stable Aliases
These are the **safest** options as they automatically use the latest stable version:

| Model Name | Description | Use Case |
|------------|-------------|----------|
| **`gemini-pro-latest`** | ✅ **CURRENTLY USED** - Most capable, latest pro model | Production apps requiring highest quality |
| `gemini-flash-latest` | Latest flash model (faster, lower cost) | High-volume applications |
| `gemini-flash-lite-latest` | Latest lightweight flash model | Resource-constrained scenarios |

### Specific Version Models
Use these if you need a specific model version:

#### Gemini 2.5 Series (Latest Generation)
- `gemini-2.5-flash` - Fast, well-rounded
- `gemini-2.5-pro` - Most advanced reasoning
- `gemini-2.5-flash-lite` - Cost-efficient

#### Gemini 2.0 Series
- `gemini-2.0-flash` - Stable workhorse
- `gemini-2.0-flash-001` - Specific stable version
- `gemini-2.0-flash-lite` - Lightweight variant
- `gemini-2.0-flash-lite-001` - Specific lite version
- `gemini-2.0-flash-exp` - Experimental features

#### Lightweight Models (Gemma)
- `gemma-3-1b-it` - 1 billion parameters
- `gemma-3-4b-it` - 4 billion parameters
- `gemma-3-12b-it` - 12 billion parameters
- `gemma-3-27b-it` - 27 billion parameters

---

## ❌ Models That DON'T Work

These models **DO NOT** exist or are not supported by v1beta API:

| Model Name | Status |
|------------|--------|
| `gemini-1.5-flash-latest` | ❌ Not found for v1beta |
| `gemini-1.5-flash` | ❌ Not found for v1beta |
| `gemini-1.5-pro` | ❌ Not found for v1beta |
| `gemini-pro` (without version) | ❌ Deprecated, not in v1beta |

---

## How to Use Models

### In Code (google_generative_ai package)

```dart
final model = GenerativeModel(
  model: 'gemini-pro-latest',  // ✅ Use WITHOUT 'models/' prefix
  apiKey: apiKey,
  generationConfig: GenerationConfig(
    temperature: 0.7,
    topK: 40,
    topP: 0.95,
    maxOutputTokens: 1024,
  ),
);
```

**Important:**
- The API returns names like `models/gemini-pro-latest`
- But in code, use names **without** the `models/` prefix
- The package adds the prefix automatically

### Direct API Call (REST)

```bash
# List all available models
curl "https://generativelanguage.googleapis.com/v1beta/models?key=YOUR_API_KEY"

# Generate content
curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-latest:generateContent?key=YOUR_API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{
    "contents": [{
      "parts": [{"text": "Your prompt here"}]
    }]
  }'
```

---

## Model Selection Guide

### Choose `gemini-pro-latest` (Current) If:
- ✅ You need highest quality responses
- ✅ Complex reasoning tasks
- ✅ Production application
- ✅ Cost is not primary concern

### Choose `gemini-flash-latest` If:
- ✅ You need faster responses
- ✅ High-volume API calls
- ✅ Lower cost priority
- ✅ Good enough quality acceptable

### Choose `gemini-flash-lite-latest` If:
- ✅ Maximum cost efficiency needed
- ✅ Simple tasks only
- ✅ Very high volume
- ✅ Mobile/edge deployment

---

## Version History & Changes

### 2025-12-11 - Round 3 (FINAL FIX)
- **Model:** `gemini-pro-latest`
- **Status:** ✅ Confirmed working with v1beta API
- **Reason:** Stable alias that automatically uses latest pro version

### 2025-12-11 - Round 2 (Failed)
- **Model:** `gemini-1.5-pro`
- **Status:** ❌ Not found for API version v1beta
- **Reason:** 1.5 series not available in v1beta

### 2025-12-11 - Round 1 (Failed)
- **Model:** `gemini-1.5-flash`
- **Status:** ❌ Not found for API version v1beta
- **Reason:** 1.5 series not available in v1beta

### Original (Failed)
- **Model:** `gemini-1.5-flash-latest`
- **Status:** ❌ Not found for API version v1beta
- **Reason:** 1.5 series not available in v1beta

---

## API Endpoint Information

**Base URL:** `https://generativelanguage.googleapis.com/v1beta`

**Key Endpoints:**
- List models: `/models`
- Generate content: `/models/{model}:generateContent`
- Get model info: `/models/{model}`

---

## Package Information

**Current Package:** `google_generative_ai: ^0.4.6`
**Status:** ⚠️ Deprecated (replaced by `firebase_ai`)
**API Version:** v1beta (hardcoded in package)

### Migration Recommendation
Consider migrating to `firebase_ai` package in future:
- ✅ Better model support
- ✅ Active development
- ✅ Unified Firebase SDK
- ✅ Access to latest Gemini models (3.0, etc.)

**Migration Guide:** https://firebase.google.com/docs/ai-logic

---

## Testing Your Model

### Quick Test Code
```dart
// Test if model works
try {
  final model = GenerativeModel(
    model: 'gemini-pro-latest',
    apiKey: 'YOUR_API_KEY',
  );

  final response = await model.generateContent([
    Content.text('Say "Model working!" if you can read this.')
  ]);

  print(response.text);  // Should print: "Model working!"
} catch (e) {
  print('Error: $e');  // If this prints, model doesn't work
}
```

### Expected Logs (Success)
```
🤖 [GEMINI AI] Initializing Gemini AI service...
   ✅ [GEMINI AI] API key loaded from environment
   ✅ [GEMINI AI] Gemini AI service initialized successfully
   📝 [GEMINI AI] Sending prompt to Gemini API...
   ✅ [GEMINI AI] Received response from Gemini API
   ✅ [GEMINI AI] Successfully parsed Gemini JSON response
```

### Error Logs (Failure)
```
🚨 [GEMINI AI] Error generating deficiency info: models/MODEL_NAME is not found for API version v1beta
```

---

## Performance Comparison

| Model | Speed | Quality | Cost | Best For |
|-------|-------|---------|------|----------|
| `gemini-pro-latest` | Slower | Highest | Higher | Production, complex tasks |
| `gemini-flash-latest` | Fast | High | Medium | General purpose |
| `gemini-flash-lite-latest` | Fastest | Good | Lowest | High volume, simple tasks |

---

## Additional Resources

- **Gemini API Docs:** https://ai.google.dev/gemini-api/docs
- **Model List (Official):** https://ai.google.dev/gemini-api/docs/models
- **Package Docs:** https://pub.dev/packages/google_generative_ai
- **Firebase AI (Migration):** https://firebase.google.com/docs/ai-logic

---

## Troubleshooting

### Error: "models/XXX is not found for API version v1beta"
**Solution:** Use `gemini-pro-latest`, `gemini-flash-latest`, or models listed in "Available Models" section above.

### Error: "API key not valid"
**Solution:** Verify `GOOGLE_GEMINI_API_KEY` in `.env` file is correct.

### Error: "Quota exceeded"
**Solution:** Check your Google AI Studio dashboard for quota limits.

### Error: "Package deprecated warnings"
**Solution:** This is expected - package is deprecated but still works. Consider migrating to `firebase_ai` long-term.

---

**Last Updated:** 2025-12-11
**Current Working Model:** `gemini-pro-latest` ✅

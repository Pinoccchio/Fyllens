I/flutter (10288):       - User ID: 76139626-70ea-4f50-82ad-4b41f5b5da17
I/flutter (10288):       - Plant ID: null
I/flutter (10288):       - Image Path:
/data/user/0/com.example.fyllens/cache/scaled_1000040558.jpg
I/flutter (10288):    ≡ƒñû [SCAN PROVIDER] Step 1: Starting ML analysis...
I/flutter (10288): ≡ƒñû [ML SERVICE] analyzePlantImage() called
I/flutter (10288):    Parameters:
I/flutter (10288):       - Plant Species: Rice
I/flutter (10288):       - Image Path:
/data/user/0/com.example.fyllens/cache/scaled_1000040558.jpg
I/flutter (10288):       - Image Exists: true
I/flutter (10288):    ≡ƒôª [ML SERVICE] Step 1: Ensuring model is loaded...
I/flutter (10288):    Γ£à [ML SERVICE] Model loaded successfully!
I/flutter (10288):       - Number of classes: 6
I/flutter (10288):       - Classes: Bacterial_Leaf_Blight, Brown_Spot, Healthy, Leaf_Blast,        
Leaf_Scald, Narrow_Brown_Spot
I/flutter (10288):      [ML SERVICE] Step 2: Preprocessing image...
I/flutter (10288):          - Reading image bytes...
I/flutter (10288):          - Image size: 92321 bytes
I/flutter (10288):          - Decoding image...
I/flutter (10288):          - Original dimensions: 1024x1024
I/flutter (10288):          - Resizing to 224x224...
I/flutter (10288):          - Converting to normalized 4D array...
I/flutter (10288):          Γ£à Preprocessing complete
I/flutter (10288):    Γ£à [ML SERVICE] Image preprocessed to 224x224
I/flutter (10288):    ≡ƒö¼ [ML SERVICE] Step 3: Running inference...
I/flutter (10288):       - Output Shape: [1, 6]
I/flutter (10288):    Γ£à [ML SERVICE] Inference completed!
I/flutter (10288):       - Raw Probabilities:
I/flutter (10288):          Bacterial_Leaf_Blight: 95.88%
I/flutter (10288):          Brown_Spot: 0.18%
I/flutter (10288):          Healthy: 0.99%
I/flutter (10288):          Leaf_Blast: 2.14%
I/flutter (10288):          Leaf_Scald: 0.44%
I/flutter (10288):          Narrow_Brown_Spot: 0.37%
I/flutter (10288):    ≡ƒôè [ML SERVICE] Step 4: Processing results...
I/flutter (10288):       - Predicted Class: Bacterial_Leaf_Blight
I/flutter (10288):       - Confidence: 95.88%
I/flutter (10288):       - Is Healthy: false
I/flutter (10288):       - Confidence Threshold: 60.0%
I/flutter (10288):    ≡ƒÄë [ML SERVICE] analyzePlantImage() completed successfully!
I/flutter (10288):    Γ£à [SCAN PROVIDER] ML Analysis completed!
I/flutter (10288):       - Deficiency: Bacterial Leaf Blight
I/flutter (10288):       - Confidence: 0.9587783813476562
I/flutter (10288):       - Is Healthy: false
I/flutter (10288):    Γÿü∩╕Å  [SCAN PROVIDER] Step 2: Uploading image to storage...
I/flutter (10288):       - Bucket: scan-images
I/flutter (10288):       - Path: 76139626-70ea-4f50-82ad-4b41f5b5da17/1765473910092.jpg
I/PowerHalMgrImpl(10288): hdl:138366, pid:10288 
I/flutter (10288):    Γ£à [SCAN PROVIDER] Image uploaded successfully!
I/flutter (10288):       - Image URL: https://ujqgmyqsmwlbbdcchnxy.supabase.co/storage/v1/object/p 
ublic/scan-images/76139626-70ea-4f50-82ad-4b41f5b5da17/1765473910092.jpg
I/flutter (10288):    ≡ƒÅÑ [SCAN PROVIDER] Health Status: DEFICIENT
I/flutter (10288):    ≡ƒîƒ [SCAN PROVIDER] Step 3: Generating enhanced treatment info with Gemini 
AI...
I/flutter (10288): ≡ƒîƒ [GEMINI AI] Generating enhanced deficiency info...
I/flutter (10288):    Plant: Rice
I/flutter (10288):    Status: Deficient
I/flutter (10288):    Deficiency: Bacterial Leaf Blight
I/flutter (10288):    Confidence: 95.88%
I/flutter (10288):    ≡ƒô¥ [GEMINI AI] Sending treatment prompt to Gemini API...
I/flutter (10288):    Γ£à [GEMINI AI] Received response from Gemini API
I/flutter (10288):    ≡ƒôè [GEMINI AI] Parsing JSON response...
I/flutter (10288):    Response length: 3112 characters
I/flutter (10288):    Γ£à [GEMINI AI] Successfully parsed deficient plant response
I/flutter (10288):       - Severity: Moderate
I/flutter (10288):       - Symptoms: 3 items
I/flutter (10288):       - Treatments: 3 items
I/flutter (10288):       - Prevention: 5 items
I/flutter (10288):    Γ£à [SCAN PROVIDER] Gemini AI treatment info generated successfully!
I/flutter (10288):       - Severity: Moderate
I/flutter (10288):       - Symptoms count: 3
I/flutter (10288):       - Treatments count: 3
I/flutter (10288):    ≡ƒÆ╛ [SCAN PROVIDER] Step 4: Saving scan result to database...
I/flutter (10288):       - Scan Data: {user_id: 76139626-70ea-4f50-82ad-4b41f5b5da17, plant_id: 
null, plant_name: Rice, image_url: https://ujqgmyqsmwlbbdcchnxy.supabase.co/storage/v1/object/publ 
ic/scan-images/76139626-70ea-4f50-82ad-4b41f5b5da17/1765473910092.jpg, deficiency_detected:        
Bacterial Leaf Blight, confidence: 0.9587783813476562, recommendations: Remove and destroy
infected leaves. Apply copper-based fungicide. Improve air circulation and avoid overhead
watering., severity: Moderate, symptoms: ["Initially, small, water-soaked, translucent spots       
appear on the leaf margins or tips. These spots enlarge and coalesce, forming characteristic       
long, wavy, or lanceolate lesions with a yellowish-green, greasy appearance.","As the disease      
progresses, the lesions lengthen, turning from yellowish-green to brown or dark brown, often with  
a distinct yellow halo or 'freckled' appearance along the margins. The affected leaf tissue dries  
out, giving the leaves a blighted or scorched look.","Severe infection can lead to the complete    
bli
I/flutter (10288):    Γ£à [SCAN PROVIDER] Database insert successful!
I/flutter (10288):       - Result: {id: 337099c5-293a-45af-8654-72ad3cca11ba, user_id:
76139626-70ea-4f50-82ad-4b41f5b5da17, plant_id: null, plant_name: Rice, image_url: https://ujqgmyq 
smwlbbdcchnxy.supabase.co/storage/v1/object/public/scan-images/76139626-70ea-4f50-82ad-4b41f5b5da1 
7/1765473910092.jpg, deficiency_detected: Bacterial Leaf Blight, confidence: 0.959,
recommendations: Remove and destroy infected leaves. Apply copper-based fungicide. Improve air     
circulation and avoid overhead watering., created_at: 2025-12-12T01:25:16.024473+00:00, severity:  
Moderate, symptoms: ["Initially, small, water-soaked, translucent spots appear on the leaf
margins or tips. These spots enlarge and coalesce, forming characteristic long, wavy, or
lanceolate lesions with a yellowish-green, greasy appearance.","As the disease progresses, the     
lesions lengthen, turning from yellowish-green to brown or dark brown, often with a distinct       
yellow halo or 'freckled' appearance along the margins. The affected leaf tissue dries out,        
giving the leaves a bl
I/flutter (10288):    ≡ƒôª [SCAN PROVIDER] Step 5: Creating ScanResult object...
I/flutter (10288):    Γ£à [SCAN PROVIDER] ScanResult created successfully!
I/flutter (10288):       - Scan ID: 337099c5-293a-45af-8654-72ad3cca11ba
I/flutter (10288):       - Deficiency: Bacterial Leaf Blight
I/flutter (10288):    ≡ƒÄë [SCAN PROVIDER] performScan() completed successfully!
I/flutter (10288):    ≡ƒôè [CAMERA SCREEN] performScan() result: true
I/flutter (10288):    Γ£à [CAMERA SCREEN] Scan successful! Navigating to results...
I/flutter (10288): ≡ƒ¢ú∩╕Å  [APP ROUTER] /home route builder called
I/flutter (10288):    Full URI: /home
I/flutter (10288):    Query parameters: {}
I/flutter (10288):    tab parameter: null
I/flutter (10288):    initialTab parsed: 0
I/flutter (10288): Γ£à [APP ROUTER] Creating MainScreen with initialTab=0
I/flutter (10288): ≡ƒöä [MAIN SCREEN] didUpdateWidget() called
I/flutter (10288):    oldWidget.initialTab: 0
I/flutter (10288):    widget.initialTab: 0
I/flutter (10288): Γä╣∩╕Å  [MAIN SCREEN] initialTab unchanged, no update needed
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138379, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138387, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138393, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138400, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138403, pid:10288 
I/PowerHalMgrImpl(10288): hdl:138406, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒöä [TAB PROVIDER] setTab(2) called
I/flutter (10288):    Previous tab: 2
I/flutter (10288): Γä╣∩╕Å  [TAB PROVIDER] Tab unchanged, already at: 2
I/flutter (10288): ≡ƒ¢ú∩╕Å  [APP ROUTER] /home route builder called
I/flutter (10288):    Full URI: /home
I/flutter (10288):    Query parameters: {}
I/flutter (10288):    tab parameter: null
I/flutter (10288):    initialTab parsed: 0
I/flutter (10288): Γ£à [APP ROUTER] Creating MainScreen with initialTab=0
I/flutter (10288): ≡ƒöä [MAIN SCREEN] didUpdateWidget() called
I/flutter (10288):    oldWidget.initialTab: 0
I/flutter (10288):    widget.initialTab: 0
I/flutter (10288): Γä╣∩╕Å  [MAIN SCREEN] initialTab unchanged, no update needed
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138423, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒöó [MAIN SCREEN] Tab tapped: 3
I/flutter (10288):    _currentIndex updated to: 3
I/flutter (10288): ≡ƒöä [TAB PROVIDER] setTab(3) called
I/flutter (10288):    Previous tab: 2
I/flutter (10288): Γ£à [TAB PROVIDER] Tab updated to: 3
I/flutter (10288): Γ£à [MAIN SCREEN] Tab change complete
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138432, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138443, pid:10288 
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138449, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138466, pid:10288 
I/ScrollIdentify(10288): on fling
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
D/TextSelection(10288): onUseCache cache=false
D/TextSelection(10288): onUseCache cache=false
I/ScrollIdentify(10288): on fling
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
D/TextSelection(10288): onUseCache cache=false
D/TextSelection(10288): onUseCache cache=false
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138496, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138507, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒöó [MAIN SCREEN] Tab tapped: 2
I/flutter (10288):    _currentIndex updated to: 2
I/flutter (10288): ≡ƒöä [TAB PROVIDER] setTab(2) called
I/flutter (10288):    Previous tab: 3
I/flutter (10288): Γ£à [TAB PROVIDER] Tab updated to: 2
I/flutter (10288): Γ£à [MAIN SCREEN] Tab change complete
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138516, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒ¢ú∩╕Å  [APP ROUTER] /home route builder called
I/flutter (10288):    Full URI: /home
I/flutter (10288):    Query parameters: {}
I/flutter (10288):    tab parameter: null
I/flutter (10288):    initialTab parsed: 0
I/flutter (10288): Γ£à [APP ROUTER] Creating MainScreen with initialTab=0
I/flutter (10288): ≡ƒöä [MAIN SCREEN] didUpdateWidget() called
I/flutter (10288):    oldWidget.initialTab: 0
I/flutter (10288):    widget.initialTab: 0
I/flutter (10288): Γä╣∩╕Å  [MAIN SCREEN] initialTab unchanged, no update needed
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
D/TextSelection(10288): onUseCache cache=false
D/ActivityThread(10288): handleResumeActivity#3 
r.window=com.android.internal.policy.PhoneWindow@dd30eb5a.mFinished = falsewillBeVisible = true    
D/skia    (10288): SkJpegCodec::onGetPixels + (1600, 1600)
I/DMABUFHEAPS(10288): Using DMA-BUF heap named: mtk_mm
D/skia    (10288): stream getLength() supported, buffer addr 0x7509ebe000 length 418048
D/skia    (10288): LoadInputStreamToMem va 0x7509ebe000  size 418048
D/libjpeg-alpha(10288): Huffman Builder run in subthread
D/libjpeg-alpha(10288): Tile Decoder (#thread:4, size:512 512 256 320x400, alignment:256x16)       
D/skia    (10288): SkJpegCodec::onGetPixels -
I/example.fyllens(10288): NativeAlloc concurrent mark compact GC freed 2136KB AllocSpace bytes, 
10(696KB) LOS objects, 63% free, 3511KB/9655KB, paused 466us,5.407ms total 45.387ms
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒô╕ [CAMERA SCREEN] Starting image processing...
I/flutter (10288):    Plant Name: Rice
I/flutter (10288):    Image Path: /data/user/0/com.example.fyllens/cache/scaled_1000040558.jpg     
I/flutter (10288):    User ID: 76139626-70ea-4f50-82ad-4b41f5b5da17
I/flutter (10288):    ≡ƒö¼ [CAMERA SCREEN] Calling performScan()...
I/flutter (10288): ≡ƒö¼ [SCAN PROVIDER] performScan() called
I/flutter (10288):    Parameters:
I/flutter (10288):       - Plant Name: Rice
I/flutter (10288):       - User ID: 76139626-70ea-4f50-82ad-4b41f5b5da17
I/flutter (10288):       - Plant ID: null
I/flutter (10288):       - Image Path:
/data/user/0/com.example.fyllens/cache/scaled_1000040558.jpg
I/flutter (10288):    ≡ƒñû [SCAN PROVIDER] Step 1: Starting ML analysis...
I/flutter (10288): ≡ƒñû [ML SERVICE] analyzePlantImage() called
I/flutter (10288):    Parameters:
I/flutter (10288):       - Plant Species: Rice
I/flutter (10288):       - Image Path:
/data/user/0/com.example.fyllens/cache/scaled_1000040558.jpg
I/flutter (10288):       - Image Exists: true
I/flutter (10288):    ≡ƒôª [ML SERVICE] Step 1: Ensuring model is loaded...
I/flutter (10288):    Γ£à [ML SERVICE] Model loaded successfully!
I/flutter (10288):       - Number of classes: 6
I/flutter (10288):       - Classes: Bacterial_Leaf_Blight, Brown_Spot, Healthy, Leaf_Blast,        
Leaf_Scald, Narrow_Brown_Spot
I/flutter (10288):      [ML SERVICE] Step 2: Preprocessing image...
I/flutter (10288):          - Reading image bytes...
I/flutter (10288):          - Image size: 92321 bytes
I/flutter (10288):          - Decoding image...
I/flutter (10288):          - Original dimensions: 1024x1024
I/flutter (10288):          - Resizing to 224x224...
I/flutter (10288):          - Converting to normalized 4D array...
I/flutter (10288):          Γ£à Preprocessing complete
I/flutter (10288):    Γ£à [ML SERVICE] Image preprocessed to 224x224
I/flutter (10288):    ≡ƒö¼ [ML SERVICE] Step 3: Running inference...
I/flutter (10288):       - Output Shape: [1, 6]
I/flutter (10288):    Γ£à [ML SERVICE] Inference completed!
I/flutter (10288):       - Raw Probabilities:
I/flutter (10288):          Bacterial_Leaf_Blight: 95.22%
I/flutter (10288):          Brown_Spot: 0.27%
I/flutter (10288):          Healthy: 1.01%
I/flutter (10288):          Leaf_Blast: 2.69%
I/flutter (10288):          Leaf_Scald: 0.44%
I/flutter (10288):          Narrow_Brown_Spot: 0.38%
I/flutter (10288):    ≡ƒôè [ML SERVICE] Step 4: Processing results...
I/flutter (10288):       - Predicted Class: Bacterial_Leaf_Blight
I/flutter (10288):       - Confidence: 95.22%
I/flutter (10288):       - Is Healthy: false
I/flutter (10288):       - Confidence Threshold: 60.0%
I/flutter (10288):    ≡ƒÄë [ML SERVICE] analyzePlantImage() completed successfully!
I/flutter (10288):    Γ£à [SCAN PROVIDER] ML Analysis completed!
I/flutter (10288):       - Deficiency: Bacterial Leaf Blight
I/flutter (10288):       - Confidence: 0.9521644711494446
I/flutter (10288):       - Is Healthy: false
I/flutter (10288):    Γÿü∩╕Å  [SCAN PROVIDER] Step 2: Uploading image to storage...
I/flutter (10288):       - Bucket: scan-images
I/flutter (10288):       - Path: 76139626-70ea-4f50-82ad-4b41f5b5da17/1765473938207.jpg
I/PowerHalMgrImpl(10288): hdl:138547, pid:10288 
I/flutter (10288):    Γ£à [SCAN PROVIDER] Image uploaded successfully!
I/flutter (10288):       - Image URL: https://ujqgmyqsmwlbbdcchnxy.supabase.co/storage/v1/object/p 
ublic/scan-images/76139626-70ea-4f50-82ad-4b41f5b5da17/1765473938207.jpg
I/flutter (10288):    ≡ƒÅÑ [SCAN PROVIDER] Health Status: DEFICIENT
I/flutter (10288):    ≡ƒîƒ [SCAN PROVIDER] Step 3: Generating enhanced treatment info with Gemini  
AI...
I/flutter (10288): ≡ƒîƒ [GEMINI AI] Generating enhanced deficiency info...
I/flutter (10288):    Plant: Rice
I/flutter (10288):    Status: Deficient
I/flutter (10288):    Deficiency: Bacterial Leaf Blight
I/flutter (10288):    Confidence: 95.22%
I/flutter (10288):    ≡ƒô¥ [GEMINI AI] Sending treatment prompt to Gemini API...
I/flutter (10288):    ≡ƒÜ¿ [GEMINI AI] Error generating deficiency info: You exceeded your 
current quota, please check your plan and billing details. For more information on this error,     
head to: https://ai.google.dev/gemini-api/docs/rate-limits. To monitor your current usage, head    
to: https://ai.dev/usage?tab=rate-limit.
I/flutter (10288): * Quota exceeded for metric:
generativelanguage.googleapis.com/generate_content_free_tier_requests, limit: 20, model:
gemini-2.5-flash-lite
I/flutter (10288): Please retry in 54.395292074s.
I/flutter (10288):    Stack Trace: #0      parseGenerateContentResponse
(package:google_generative_ai/src/api.dart:582:54)
I/flutter (10288): <asynchronous suspension>
I/flutter (10288): #1      GeminiAIService.generateDeficiencyInfo
(package:fyllens/services/gemini_ai_service.dart:185:24)
I/flutter (10288): <asynchronous suspension>
I/flutter (10288): #2      ScanProvider.performScan
(package:fyllens/providers/scan_provider.dart:83:22)
I/flutter (10288): <asynchronous suspension>
I/flutter (10288): #3      _CameraScreenState._processImage
(package:fyllens/screens/scan/camera_screen.dart:118:23)
I/flutter (10288): <asynchronous suspension>
I/flutter (10288):    Γä╣∩╕Å  [GEMINI AI] Using fallback deficiency information
I/flutter (10288):    Γ£à [SCAN PROVIDER] Gemini AI treatment info generated successfully!
I/flutter (10288):       - Severity: Severe
I/flutter (10288):       - Symptoms count: 3
I/flutter (10288):       - Treatments count: 2
I/flutter (10288):    ≡ƒÆ╛ [SCAN PROVIDER] Step 4: Saving scan result to database...
I/flutter (10288):       - Scan Data: {user_id: 76139626-70ea-4f50-82ad-4b41f5b5da17, plant_id: 
null, plant_name: Rice, image_url: https://ujqgmyqsmwlbbdcchnxy.supabase.co/storage/v1/object/publ 
ic/scan-images/76139626-70ea-4f50-82ad-4b41f5b5da17/1765473938207.jpg, deficiency_detected:        
Bacterial Leaf Blight, confidence: 0.9521644711494446, recommendations: Remove and destroy
infected leaves. Apply copper-based fungicide. Improve air circulation and avoid overhead
watering., severity: Severe, symptoms: ["Visual signs of Bacterial Leaf Blight in
Rice","Discoloration or spotting on plant tissue","Changes in growth patterns or leaf
appearance"], gemini_treatments: [{"title":"Immediate Treatment","description":"Apply appropriate  
remedies for Bacterial Leaf Blight","icon":"fertilizer"},{"title":"Long-term
Management","description":"Improve soil conditions and plant care practices","icon":"organic"}],   
prevention_tips: ["Regular monitoring and early detection","Proper nutrition and soil
management","Good cultural practices and sanitati
I/flutter (10288):    Γ£à [SCAN PROVIDER] Database insert successful!
I/flutter (10288):       - Result: {id: 6e706d29-9c51-4214-a96c-88adcec98993, user_id:
76139626-70ea-4f50-82ad-4b41f5b5da17, plant_id: null, plant_name: Rice, image_url: https://ujqgmyq 
smwlbbdcchnxy.supabase.co/storage/v1/object/public/scan-images/76139626-70ea-4f50-82ad-4b41f5b5da1 
7/1765473938207.jpg, deficiency_detected: Bacterial Leaf Blight, confidence: 0.952,
recommendations: Remove and destroy infected leaves. Apply copper-based fungicide. Improve air     
circulation and avoid overhead watering., created_at: 2025-12-12T01:25:39.71468+00:00, severity:   
Severe, symptoms: ["Visual signs of Bacterial Leaf Blight in Rice","Discoloration or spotting on   
plant tissue","Changes in growth patterns or leaf appearance"], gemini_treatments:
[{"title":"Immediate Treatment","description":"Apply appropriate remedies for Bacterial Leaf       
Blight","icon":"fertilizer"},{"title":"Long-term Management","description":"Improve soil
conditions and plant care practices","icon":"organic"}], prevention_tips: ["Regular monitoring     
and early detection","Prop
I/flutter (10288):    ≡ƒôª [SCAN PROVIDER] Step 5: Creating ScanResult object...
I/flutter (10288):    Γ£à [SCAN PROVIDER] ScanResult created successfully!
I/flutter (10288):       - Scan ID: 6e706d29-9c51-4214-a96c-88adcec98993
I/flutter (10288):       - Deficiency: Bacterial Leaf Blight
I/flutter (10288):    ≡ƒÄë [SCAN PROVIDER] performScan() completed successfully!
I/flutter (10288):    ≡ƒôè [CAMERA SCREEN] performScan() result: true
I/flutter (10288):    Γ£à [CAMERA SCREEN] Scan successful! Navigating to results...
I/flutter (10288): ≡ƒ¢ú∩╕Å  [APP ROUTER] /home route builder called
I/flutter (10288):    Full URI: /home
I/flutter (10288):    Query parameters: {}
I/flutter (10288):    tab parameter: null
I/flutter (10288):    initialTab parsed: 0
I/flutter (10288): Γ£à [APP ROUTER] Creating MainScreen with initialTab=0
I/flutter (10288): ≡ƒöä [MAIN SCREEN] didUpdateWidget() called
I/flutter (10288):    oldWidget.initialTab: 0
I/flutter (10288):    widget.initialTab: 0
I/flutter (10288): Γä╣∩╕Å  [MAIN SCREEN] initialTab unchanged, no update needed
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138558, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒ¢ú∩╕Å  [APP ROUTER] /home route builder called
I/flutter (10288):    Full URI: /home
I/flutter (10288):    Query parameters: {}
I/flutter (10288):    tab parameter: null
I/flutter (10288):    initialTab parsed: 0
I/flutter (10288): Γ£à [APP ROUTER] Creating MainScreen with initialTab=0
I/flutter (10288): ≡ƒöä [MAIN SCREEN] didUpdateWidget() called
I/flutter (10288):    oldWidget.initialTab: 0
I/flutter (10288):    widget.initialTab: 0
I/flutter (10288): Γä╣∩╕Å  [MAIN SCREEN] initialTab unchanged, no update needed
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒöó [MAIN SCREEN] Tab tapped: 3
I/flutter (10288):    _currentIndex updated to: 3
I/flutter (10288): ≡ƒöä [TAB PROVIDER] setTab(3) called
I/flutter (10288):    Previous tab: 2
I/flutter (10288): Γ£à [TAB PROVIDER] Tab updated to: 3
I/flutter (10288): Γ£à [MAIN SCREEN] Tab change complete
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138574, pid:10288
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138590, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒöä [RESCAN CALLBACK] Callback triggered
I/flutter (10288):    Context mounted: true
I/flutter (10288): ≡ƒº╣ [RESCAN CALLBACK] Clearing current scan...
I/flutter (10288): Γ£à [RESCAN CALLBACK] Scan cleared successfully
I/flutter (10288): ≡ƒöÖ [RESCAN CALLBACK] Popping HistoryResultScreen...
I/flutter (10288): Γ£à [RESCAN CALLBACK] Navigator.pop() executed
I/flutter (10288): ≡ƒÄ» [RESCAN CALLBACK] Switching to Scan tab via TabProvider...
I/flutter (10288): ≡ƒöä [TAB PROVIDER] setTab(2) called
I/flutter (10288):    Previous tab: 3
I/flutter (10288): Γ£à [TAB PROVIDER] Tab updated to: 2
I/flutter (10288): Γ£à [RESCAN CALLBACK] Tab switch complete!
I/flutter (10288): ≡ƒôí [MAIN SCREEN] TabProvider changed: 2
I/flutter (10288):    Syncing _currentIndex from 3 to 2
I/flutter (10288): Γ£à [MAIN SCREEN] _currentIndex synced to: 2
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒ¢ú∩╕Å  [APP ROUTER] /home route builder called
I/flutter (10288):    Full URI: /home
I/flutter (10288):    Query parameters: {}
I/flutter (10288):    tab parameter: null
I/flutter (10288):    initialTab parsed: 0
I/flutter (10288): Γ£à [APP ROUTER] Creating MainScreen with initialTab=0
I/flutter (10288): ≡ƒöä [MAIN SCREEN] didUpdateWidget() called
I/flutter (10288):    oldWidget.initialTab: 0
I/flutter (10288):    widget.initialTab: 0
I/flutter (10288): Γä╣∩╕Å  [MAIN SCREEN] initialTab unchanged, no update needed
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
D/TextSelection(10288): onUseCache cache=false
D/ActivityThread(10288): handleResumeActivity#3 
r.window=com.android.internal.policy.PhoneWindow@dd30eb5a.mFinished = falsewillBeVisible = true    
D/skia    (10288): SkJpegCodec::onGetPixels + (1600, 1600)
I/DMABUFHEAPS(10288): Using DMA-BUF heap named: mtk_mm
D/skia    (10288): stream getLength() supported, buffer addr 0x7509ebe000 length 418048
D/skia    (10288): LoadInputStreamToMem va 0x7509ebe000  size 418048
D/libjpeg-alpha(10288): Huffman Builder run in subthread
D/libjpeg-alpha(10288): Tile Decoder (#thread:4, size:512 512 256 320x400, alignment:256x16)       
D/skia    (10288): SkJpegCodec::onGetPixels -
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒô╕ [CAMERA SCREEN] Starting image processing...
I/flutter (10288):    Plant Name: Rice
I/flutter (10288):    Image Path: /data/user/0/com.example.fyllens/cache/scaled_1000040558.jpg     
I/flutter (10288):    User ID: 76139626-70ea-4f50-82ad-4b41f5b5da17
I/flutter (10288):    ≡ƒö¼ [CAMERA SCREEN] Calling performScan()...
I/flutter (10288): ≡ƒö¼ [SCAN PROVIDER] performScan() called
I/flutter (10288):    Parameters:
I/flutter (10288):       - Plant Name: Rice
I/flutter (10288):       - User ID: 76139626-70ea-4f50-82ad-4b41f5b5da17
I/flutter (10288):       - Plant ID: null
I/flutter (10288):       - Image Path:
/data/user/0/com.example.fyllens/cache/scaled_1000040558.jpg
I/flutter (10288):    ≡ƒñû [SCAN PROVIDER] Step 1: Starting ML analysis...
I/flutter (10288): ≡ƒñû [ML SERVICE] analyzePlantImage() called
I/flutter (10288):    Parameters:
I/flutter (10288):       - Plant Species: Rice
I/flutter (10288):       - Image Path:
/data/user/0/com.example.fyllens/cache/scaled_1000040558.jpg
I/flutter (10288):       - Image Exists: true
I/flutter (10288):    ≡ƒôª [ML SERVICE] Step 1: Ensuring model is loaded...
I/flutter (10288):    Γ£à [ML SERVICE] Model loaded successfully!
I/flutter (10288):       - Number of classes: 6
I/flutter (10288):       - Classes: Bacterial_Leaf_Blight, Brown_Spot, Healthy, Leaf_Blast,        
Leaf_Scald, Narrow_Brown_Spot
I/flutter (10288):      [ML SERVICE] Step 2: Preprocessing image...
I/flutter (10288):          - Reading image bytes...
I/flutter (10288):          - Image size: 92321 bytes
I/flutter (10288):          - Decoding image...
I/flutter (10288):          - Original dimensions: 1024x1024
I/flutter (10288):          - Resizing to 224x224...
I/flutter (10288):          - Converting to normalized 4D array...
I/flutter (10288):          Γ£à Preprocessing complete
I/flutter (10288):    Γ£à [ML SERVICE] Image preprocessed to 224x224
I/flutter (10288):    ≡ƒö¼ [ML SERVICE] Step 3: Running inference...
I/flutter (10288):       - Output Shape: [1, 6]
I/flutter (10288):    Γ£à [ML SERVICE] Inference completed!
I/flutter (10288):       - Raw Probabilities:
I/flutter (10288):          Bacterial_Leaf_Blight: 95.88%
I/flutter (10288):          Brown_Spot: 0.18%
I/flutter (10288):          Healthy: 0.99%
I/flutter (10288):          Leaf_Blast: 2.14%
I/flutter (10288):          Leaf_Scald: 0.44%
I/flutter (10288):          Narrow_Brown_Spot: 0.37%
I/flutter (10288):    ≡ƒôè [ML SERVICE] Step 4: Processing results...
I/flutter (10288):       - Predicted Class: Bacterial_Leaf_Blight
I/flutter (10288):       - Confidence: 95.88%
I/flutter (10288):       - Is Healthy: false
I/flutter (10288):       - Confidence Threshold: 60.0%
I/flutter (10288):    ≡ƒÄë [ML SERVICE] analyzePlantImage() completed successfully!
I/flutter (10288):    Γ£à [SCAN PROVIDER] ML Analysis completed!
I/flutter (10288):       - Deficiency: Bacterial Leaf Blight
I/flutter (10288):       - Confidence: 0.9587783813476562
I/flutter (10288):       - Is Healthy: false
I/flutter (10288):    Γÿü∩╕Å  [SCAN PROVIDER] Step 2: Uploading image to storage...
I/flutter (10288):       - Bucket: scan-images
I/flutter (10288):       - Path: 76139626-70ea-4f50-82ad-4b41f5b5da17/1765473953932.jpg
I/PowerHalMgrImpl(10288): hdl:138625, pid:10288 
I/flutter (10288):    Γ£à [SCAN PROVIDER] Image uploaded successfully!
I/flutter (10288):       - Image URL: https://ujqgmyqsmwlbbdcchnxy.supabase.co/storage/v1/object/p 
ublic/scan-images/76139626-70ea-4f50-82ad-4b41f5b5da17/1765473953932.jpg
I/flutter (10288):    ≡ƒÅÑ [SCAN PROVIDER] Health Status: DEFICIENT
I/flutter (10288):    ≡ƒîƒ [SCAN PROVIDER] Step 3: Generating enhanced treatment info with Gemini  
AI...
I/flutter (10288): ≡ƒîƒ [GEMINI AI] Generating enhanced deficiency info...
I/flutter (10288):    Plant: Rice
I/flutter (10288):    Status: Deficient
I/flutter (10288):    Deficiency: Bacterial Leaf Blight
I/flutter (10288):    Confidence: 95.88%
I/flutter (10288):    ≡ƒô¥ [GEMINI AI] Sending treatment prompt to Gemini API...
I/flutter (10288):    ≡ƒÜ¿ [GEMINI AI] Error generating deficiency info: You exceeded your 
current quota, please check your plan and billing details. For more information on this error,     
head to: https://ai.google.dev/gemini-api/docs/rate-limits. To monitor your current usage, head    
to: https://ai.dev/usage?tab=rate-limit.
I/flutter (10288): * Quota exceeded for metric:
generativelanguage.googleapis.com/generate_content_free_tier_requests, limit: 20, model:
gemini-2.5-flash-lite
I/flutter (10288): Please retry in 38.978894149s.
I/flutter (10288):    Stack Trace: #0      parseGenerateContentResponse
(package:google_generative_ai/src/api.dart:582:54)
I/flutter (10288): <asynchronous suspension>
I/flutter (10288): #1      GeminiAIService.generateDeficiencyInfo
(package:fyllens/services/gemini_ai_service.dart:185:24)
I/flutter (10288): <asynchronous suspension>
I/flutter (10288): #2      ScanProvider.performScan
(package:fyllens/providers/scan_provider.dart:83:22)
I/flutter (10288): <asynchronous suspension>
I/flutter (10288): #3      _CameraScreenState._processImage
(package:fyllens/screens/scan/camera_screen.dart:118:23)
I/flutter (10288): <asynchronous suspension>
I/flutter (10288):    Γä╣∩╕Å  [GEMINI AI] Using fallback deficiency information
I/flutter (10288):    Γ£à [SCAN PROVIDER] Gemini AI treatment info generated successfully!
I/flutter (10288):       - Severity: Severe
I/flutter (10288):       - Symptoms count: 3
I/flutter (10288):       - Treatments count: 2
I/flutter (10288):    ≡ƒÆ╛ [SCAN PROVIDER] Step 4: Saving scan result to database...
I/flutter (10288):       - Scan Data: {user_id: 76139626-70ea-4f50-82ad-4b41f5b5da17, plant_id: 
null, plant_name: Rice, image_url: https://ujqgmyqsmwlbbdcchnxy.supabase.co/storage/v1/object/publ 
ic/scan-images/76139626-70ea-4f50-82ad-4b41f5b5da17/1765473953932.jpg, deficiency_detected:        
Bacterial Leaf Blight, confidence: 0.9587783813476562, recommendations: Remove and destroy
infected leaves. Apply copper-based fungicide. Improve air circulation and avoid overhead
watering., severity: Severe, symptoms: ["Visual signs of Bacterial Leaf Blight in
Rice","Discoloration or spotting on plant tissue","Changes in growth patterns or leaf
appearance"], gemini_treatments: [{"title":"Immediate Treatment","description":"Apply appropriate  
remedies for Bacterial Leaf Blight","icon":"fertilizer"},{"title":"Long-term
Management","description":"Improve soil conditions and plant care practices","icon":"organic"}],   
prevention_tips: ["Regular monitoring and early detection","Proper nutrition and soil
management","Good cultural practices and sanitati
I/flutter (10288):    Γ£à [SCAN PROVIDER] Database insert successful!
I/flutter (10288):       - Result: {id: 6f5b31f8-797b-4e95-bc4e-ec47cfa42969, user_id:
76139626-70ea-4f50-82ad-4b41f5b5da17, plant_id: null, plant_name: Rice, image_url: https://ujqgmyq 
smwlbbdcchnxy.supabase.co/storage/v1/object/public/scan-images/76139626-70ea-4f50-82ad-4b41f5b5da1 
7/1765473953932.jpg, deficiency_detected: Bacterial Leaf Blight, confidence: 0.959,
recommendations: Remove and destroy infected leaves. Apply copper-based fungicide. Improve air     
circulation and avoid overhead watering., created_at: 2025-12-12T01:25:55.122743+00:00, severity:  
Severe, symptoms: ["Visual signs of Bacterial Leaf Blight in Rice","Discoloration or spotting on   
plant tissue","Changes in growth patterns or leaf appearance"], gemini_treatments:
[{"title":"Immediate Treatment","description":"Apply appropriate remedies for Bacterial Leaf       
Blight","icon":"fertilizer"},{"title":"Long-term Management","description":"Improve soil
conditions and plant care practices","icon":"organic"}], prevention_tips: ["Regular monitoring     
and early detection","Pro
I/flutter (10288):    ≡ƒôª [SCAN PROVIDER] Step 5: Creating ScanResult object...
I/flutter (10288):    Γ£à [SCAN PROVIDER] ScanResult created successfully!
I/flutter (10288):       - Scan ID: 6f5b31f8-797b-4e95-bc4e-ec47cfa42969
I/flutter (10288):       - Deficiency: Bacterial Leaf Blight
I/flutter (10288):    ≡ƒÄë [SCAN PROVIDER] performScan() completed successfully!
I/flutter (10288):    ≡ƒôè [CAMERA SCREEN] performScan() result: true
I/flutter (10288):    Γ£à [CAMERA SCREEN] Scan successful! Navigating to results...
I/flutter (10288): ≡ƒ¢ú∩╕Å  [APP ROUTER] /home route builder called
I/flutter (10288):    Full URI: /home
I/flutter (10288):    Query parameters: {}
I/flutter (10288):    tab parameter: null
I/flutter (10288):    initialTab parsed: 0
I/flutter (10288): Γ£à [APP ROUTER] Creating MainScreen with initialTab=0
I/flutter (10288): ≡ƒöä [MAIN SCREEN] didUpdateWidget() called
I/flutter (10288):    oldWidget.initialTab: 0
I/flutter (10288):    widget.initialTab: 0
I/flutter (10288): Γä╣∩╕Å  [MAIN SCREEN] initialTab unchanged, no update needed
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138636, pid:10288 
I/PowerHalMgrImpl(10288): hdl:138639, pid:10288 
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138647, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138654, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138661, pid:10288
I/ScrollIdentify(10288): on fling
I/flutter (10288): ≡ƒ¢ú∩╕Å  [APP ROUTER] /home route builder called
I/flutter (10288):    Full URI: /home
I/flutter (10288):    Query parameters: {}
I/flutter (10288):    tab parameter: null
I/flutter (10288):    initialTab parsed: 0
I/flutter (10288): Γ£à [APP ROUTER] Creating MainScreen with initialTab=0
I/flutter (10288): ≡ƒöä [MAIN SCREEN] didUpdateWidget() called
I/flutter (10288):    oldWidget.initialTab: 0
I/flutter (10288):    widget.initialTab: 0
I/flutter (10288): Γä╣∩╕Å  [MAIN SCREEN] initialTab unchanged, no update needed
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒöó [MAIN SCREEN] Tab tapped: 3
I/flutter (10288):    _currentIndex updated to: 3
I/flutter (10288): ≡ƒöä [TAB PROVIDER] setTab(3) called
I/flutter (10288):    Previous tab: 2
I/flutter (10288): Γ£à [TAB PROVIDER] Tab updated to: 3
I/flutter (10288): Γ£à [MAIN SCREEN] Tab change complete
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138671, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138687, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138692, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138698, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒöó [MAIN SCREEN] Tab tapped: 2
I/flutter (10288):    _currentIndex updated to: 2
I/flutter (10288): ≡ƒöä [TAB PROVIDER] setTab(2) called
I/flutter (10288):    Previous tab: 3
I/flutter (10288): Γ£à [TAB PROVIDER] Tab updated to: 2
I/flutter (10288): Γ£à [MAIN SCREEN] Tab change complete

Performing hot restart...
Restarted application in 2,284ms.
I/flutter (10288): Γ£à Environment variables loaded from .env file
I/flutter (10288): 
I/flutter (10288): ≡ƒöì Validating Supabase Configuration...
I/flutter (10288): Γ£à Supabase configuration valid
I/flutter (10288):    URL length: 40 characters
I/flutter (10288):    Key length: 208 characters
I/flutter (10288):
I/flutter (10288): ≡ƒöº Initializing Supabase...
I/flutter (10288): ***** Supabase init completed Instance of 'Supabase'
I/flutter (10288): ***** SupabaseDeepLinkingMixin startAuthObserver
I/flutter (10288): **** onAuthStateChange: AuthChangeEvent.initialSession
I/flutter (10288): {"access_token":"eyJhbGciOiJIUzI1NiIsImtpZCI6IlhjS1dUbk15S3p4YmFGL28iLCJ0eXAiOi
JKV1QifQ.eyJpc3MiOiJodHRwczovL3VqcWdteXFzbXdsYmJkY2Nobnh5LnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiI3N 
jEzOTYyNi03MGVhLTRmNTAtODJhZC00YjQxZjViNWRhMTciLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzY1NDc1Mjg 
0LCJpYXQiOjE3NjU0NzE2ODQsImVtYWlsIjoiamV4eGVqc0BnbWFpbC5jb20iLCJwaG9uZSI6IiIsImFwcF9tZXRhZGF0YSI6e 
yJwcm92aWRlciI6ImVtYWlsIiwicHJvdmlkZXJzIjpbImVtYWlsIl19LCJ1c2VyX21ldGFkYXRhIjp7ImVtYWlsIjoiamV4eGV 
qc0BnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGhvbmVfdmVyaWZpZWQiOmZhbHNlLCJzdWIiOiI3NjEzOTYyN 
i03MGVhLTRmNTAtODJhZC00YjQxZjViNWRhMTcifSwicm9sZSI6ImF1dGhlbnRpY2F0ZWQiLCJhYWwiOiJhYWwxIiwiYW1yIjp 
beyJtZXRob2QiOiJwYXNzd29yZCIsInRpbWVzdGFtcCI6MTc2NTQzNjQyOX1dLCJzZXNzaW9uX2lkIjoiYzgwZDZiMTgtZTNmZ 
S00NmE0LWE2MWMtNzQ4YzlkM2ExYzgyIiwiaXNfYW5vbnltb3VzIjpmYWxzZX0.C1IYhpWYhkA_kFCsqVvW3UFhDvlUXZm4pJV 
3JzXLbyY","expires_in":3600,"expires_at":1765475284,"refresh_token":"fsdqs2ktpzvy","token_type":"b 
earer","provider_token":null,"provider_refresh_token":null,"us
I/flutter (10288): Γ£à Supabase initialized successfully
I/flutter (10288):    URL: https://ujqgmyqsmwlbbdcchnxy.s...upabase.co
I/flutter (10288): **** onAuthStateChange: AuthChangeEvent.initialSession
I/flutter (10288): {"access_token":"eyJhbGciOiJIUzI1NiIsImtpZCI6IlhjS1dUbk15S3p4YmFGL28iLCJ0eXAiOi
JKV1QifQ.eyJpc3MiOiJodHRwczovL3VqcWdteXFzbXdsYmJkY2Nobnh5LnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiI3N 
jEzOTYyNi03MGVhLTRmNTAtODJhZC00YjQxZjViNWRhMTciLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzY1NDc1Mjg 
0LCJpYXQiOjE3NjU0NzE2ODQsImVtYWlsIjoiamV4eGVqc0BnbWFpbC5jb20iLCJwaG9uZSI6IiIsImFwcF9tZXRhZGF0YSI6e 
yJwcm92aWRlciI6ImVtYWlsIiwicHJvdmlkZXJzIjpbImVtYWlsIl19LCJ1c2VyX21ldGFkYXRhIjp7ImVtYWlsIjoiamV4eGV 
qc0BnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGhvbmVfdmVyaWZpZWQiOmZhbHNlLCJzdWIiOiI3NjEzOTYyN 
i03MGVhLTRmNTAtODJhZC00YjQxZjViNWRhMTcifSwicm9sZSI6ImF1dGhlbnRpY2F0ZWQiLCJhYWwiOiJhYWwxIiwiYW1yIjp 
beyJtZXRob2QiOiJwYXNzd29yZCIsInRpbWVzdGFtcCI6MTc2NTQzNjQyOX1dLCJzZXNzaW9uX2lkIjoiYzgwZDZiMTgtZTNmZ 
S00NmE0LWE2MWMtNzQ4YzlkM2ExYzgyIiwiaXNfYW5vbnltb3VzIjpmYWxzZX0.C1IYhpWYhkA_kFCsqVvW3UFhDvlUXZm4pJV 
3JzXLbyY","expires_in":3600,"expires_at":1765475284,"refresh_token":"fsdqs2ktpzvy","token_type":"b 
earer","provider_token":null,"provider_refresh_token":null,"us
I/flutter (10288): 
I/flutter (10288): ≡ƒöÉ AuthProvider: Initializing...
I/flutter (10288):    Γ£à Found existing user session: jexxejs@gmail.com
I/flutter (10288):    User ID: 76139626-70ea-4f50-82ad-4b41f5b5da17
I/flutter (10288):    ≡ƒôÑ Fetching profile data from database...
I/flutter (10288):    Γ£à Profile data loaded from database
I/flutter (10288):    Avatar URL: https://ujqgmyqsmwlbbdcchnxy.supabase.co/storage/v1/object/publi 
c/avatars/76139626-70ea-4f50-82ad-4b41f5b5da17/avatar_1765417845080.jpg
I/flutter (10288):    Setting up auth state listener...
I/flutter (10288): Γ£à AuthProvider initialized successfully
I/flutter (10288): ≡ƒöÉ AuthProvider: Auth state changed - User signed in: jexxejs@gmail.com       
I/flutter (10288):    ≡ƒôÑ Fetching profile from database...
I/flutter (10288):    Γ£à Profile loaded from database
I/flutter (10288):    Avatar URL: https://ujqgmyqsmwlbbdcchnxy.supabase.co/storage/v1/object/publi 
c/avatars/76139626-70ea-4f50-82ad-4b41f5b5da17/avatar_1765417845080.jpg
I/flutter (10288): 
I/flutter (10288): ΓÅ│ Splash Screen: Waiting for AuthProvider initialization...
I/flutter (10288):    Γ£à AuthProvider initialized (took 0ms)
I/flutter (10288):
I/flutter (10288): ≡ƒöì Splash Screen: Checking auth state
I/flutter (10288):    - isInitialized: true
I/flutter (10288):    - isAuthenticated: true
I/flutter (10288):    - currentUser: jexxejs@gmail.com
I/flutter (10288):    Γ£à User authenticated ΓåÆ Navigating to HOME
I/flutter (10288): ≡ƒ¢ú∩╕Å  [APP ROUTER] /home route builder called
I/flutter (10288):    Full URI: /home
I/flutter (10288):    Query parameters: {}
I/flutter (10288):    tab parameter: null
I/flutter (10288):    initialTab parsed: 0
I/flutter (10288): Γ£à [APP ROUTER] Creating MainScreen with initialTab=0
I/flutter (10288): ≡ƒÅá [MAIN SCREEN] initState() called
I/flutter (10288):    widget.initialTab: 0
I/flutter (10288):    _currentIndex set to: 0
I/flutter (10288): Γ£à [MAIN SCREEN] initState() completed
I/flutter (10288): ≡ƒôÜ [HISTORY] Loading scan history for user: 
76139626-70ea-4f50-82ad-4b41f5b5da17
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒöó [MAIN SCREEN] Tab tapped: 2
I/flutter (10288):    _currentIndex updated to: 2
I/flutter (10288): ≡ƒöä [TAB PROVIDER] setTab(2) called
I/flutter (10288):    Previous tab: 0
I/flutter (10288): Γ£à [TAB PROVIDER] Tab updated to: 2
I/flutter (10288): Γ£à [MAIN SCREEN] Tab change complete
D/TextSelection(10288): onUseCache cache=false
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138738, pid:10288 
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138743, pid:10288 
D/TextSelection(10288): onUseCache cache=false
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138752, pid:10288 
D/TextSelection(10288): onUseCache cache=false
D/TextSelection(10288): onUseCache cache=false
I/PowerHalMgrImpl(10288): hdl:138760, pid:10288 
I/ScrollIdentify(10288): on fling
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒ¢ú∩╕Å  [APP ROUTER] /home route builder called
I/flutter (10288):    Full URI: /home
I/flutter (10288):    Query parameters: {}
I/flutter (10288):    tab parameter: null
I/flutter (10288):    initialTab parsed: 0
I/flutter (10288): Γ£à [APP ROUTER] Creating MainScreen with initialTab=0
I/flutter (10288): ≡ƒöä [MAIN SCREEN] didUpdateWidget() called
I/flutter (10288):    oldWidget.initialTab: 0
I/flutter (10288):    widget.initialTab: 0
I/flutter (10288): Γä╣∩╕Å  [MAIN SCREEN] initialTab unchanged, no update needed
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
D/TextSelection(10288): onUseCache cache=false
D/VRI[MainActivity](10288): visibilityChanged oldVisibility=true newVisibility=false
D/BufferQueueConsumer(10288): 
[SurfaceView[com.example.fyllens/com.example.fyllens.MainActivity]#1(BLAST
Consumer)1](id:283000000001,api:0,p:-1,c:10288) disconnect
D/BufferQueueConsumer(10288): [VRI[MainActivity]#0(BLAST 
Consumer)0](id:283000000000,api:0,p:-1,c:10288) disconnect
D/ActivityThread(10288): handleResumeActivity#3 
r.window=com.android.internal.policy.PhoneWindow@dd30eb5a.mFinished = falsewillBeVisible = true    
D/MediaScannerConnection(10288): detect SCAN_FILE action for paths
D/BufferQueueConsumer(10288): [](id:283000000002,api:0,p:-1,c:10288) connect: 
controlledByApp=false
D/BufferQueueConsumer(10288): [](id:283000000003,api:0,p:-1,c:10288) connect:
controlledByApp=false
E/gralloc4(10288): ERROR: Format allocation info not found for format: 38
E/gralloc4(10288): ERROR: Format allocation info not found for format: 0
E/gralloc4(10288): Invalid base format! req_base_format = 0x0, req_format = 0x38, type = 0x0       
E/gralloc4(10288): ERROR: Unrecognized and/or unsupported format 0x38 and usage 0xb00
E/Gralloc4(10288): isSupported(1, 1, 56, 1, ...) failed with 5
E/GraphicBufferAllocator(10288): Failed to allocate (4 x 4) layerCount 1 format 56 usage b00: 5    
E/AHardwareBuffer(10288): GraphicBuffer(w=4, h=4, lc=1) failed (Unknown error -5), handle=0x0      
E/gralloc4(10288): ERROR: Format allocation info not found for format: 3b
E/gralloc4(10288): ERROR: Format allocation info not found for format: 0
E/gralloc4(10288): Invalid base format! req_base_format = 0x0, req_format = 0x3b, type = 0x0
E/gralloc4(10288): ERROR: Unrecognized and/or unsupported format 0x3b and usage 0xb00
E/Gralloc4(10288): isSupported(1, 1, 59, 1, ...) failed with 5
E/GraphicBufferAllocator(10288): Failed to allocate (4 x 4) layerCount 1 format 59 usage b00: 5    
E/AHardwareBuffer(10288): GraphicBuffer(w=4, h=4, lc=1) failed (Unknown error -5), handle=0x0      
E/gralloc4(10288): ERROR: Format allocation info not found for format: 38
E/gralloc4(10288): ERROR: Format allocation info not found for format: 0
E/gralloc4(10288): Invalid base format! req_base_format = 0x0, req_format = 0x38, type = 0x0       
E/gralloc4(10288): ERROR: Unrecognized and/or unsupported format 0x38 and usage 0xb00
E/Gralloc4(10288): isSupported(1, 1, 56, 1, ...) failed with 5
E/GraphicBufferAllocator(10288): Failed to allocate (4 x 4) layerCount 1 format 56 usage b00: 5    
E/AHardwareBuffer(10288): GraphicBuffer(w=4, h=4, lc=1) failed (Unknown error -5), handle=0x0      
E/gralloc4(10288): ERROR: Format allocation info not found for format: 3b
E/gralloc4(10288): ERROR: Format allocation info not found for format: 0
E/gralloc4(10288): Invalid base format! req_base_format = 0x0, req_format = 0x3b, type = 0x0       
E/gralloc4(10288): ERROR: Unrecognized and/or unsupported format 0x3b and usage 0xb00
E/Gralloc4(10288): isSupported(1, 1, 59, 1, ...) failed with 5
E/GraphicBufferAllocator(10288): Failed to allocate (4 x 4) layerCount 1 format 59 usage b00: 5    
E/AHardwareBuffer(10288): GraphicBuffer(w=4, h=4, lc=1) failed (Unknown error -5), handle=0x0      
D/MediaScannerConnection(10288): Scanned 
/data/user/0/com.example.fyllens/cache/477b3e02-4546-47f4-ab7d-390ad1c50762823039594819716348.jpg  
to null
D/skia    (10288): SkJpegCodec::onGetPixels + (2976, 3968)
I/DMABUFHEAPS(10288): Using DMA-BUF heap named: mtk_mm
D/skia    (10288): stream getLength() supported, buffer addr 0x7454b38000 length 6395264
D/skia    (10288): LoadInputStreamToMem va 0x7454b38000  size 6395264
D/libjpeg-alpha(10288): Huffman Builder run in subthread
D/libjpeg-alpha(10288): Tile Decoder (#thread:4, size:768 768 768 672x992, alignment:256x16)       
W/Choreographer(10288): Already have a pending vsync event.  There should only be one at a time.
D/skia    (10288): SkJpegCodec::onGetPixels -
I/example.fyllens(10288): NativeAlloc concurrent mark compact GC freed 2249KB AllocSpace bytes, 
12(800KB) LOS objects, 66% free, 3083KB/9227KB, paused 603us,8.389ms total 60.876ms
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and 
/data/app/~~6e-mlFhKqiIBk93Zwf-wyA==/cn.wps.moffice_eng-LjtB5y2UMmtMJNOtyDcjTw==/base.apk' with 1  
weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~6e-mlFh
KqiIBk93Zwf-wyA==/cn.wps.moffice_eng-LjtB5y2UMmtMJNOtyDcjTw==/split_config.arm64_v8a.apk' with 1   
weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~6e-mlFh 
KqiIBk93Zwf-wyA==/cn.wps.moffice_eng-LjtB5y2UMmtMJNOtyDcjTw==/split_config.en.apk' with 1 weak     
references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~6e-mlFh
KqiIBk93Zwf-wyA==/cn.wps.moffice_eng-LjtB5y2UMmtMJNOtyDcjTw==/split_config.xxhdpi.apk' with 1      
weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and 
/data/app/~~6e-mlFhKqiIBk93Zwf-wyA==/cn.wps.moffice_eng-LjtB5y2UMmtMJNOtyDcjTw==/split_memo.apk'   
with 1 weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~6e-mlFh 
KqiIBk93Zwf-wyA==/cn.wps.moffice_eng-LjtB5y2UMmtMJNOtyDcjTw==/split_memo.config.xxhdpi.apk' with   
1 weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~6e-mlFh 
KqiIBk93Zwf-wyA==/cn.wps.moffice_eng-LjtB5y2UMmtMJNOtyDcjTw==/split_vassonic.apk' with 1 weak 
references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~6e-mlFh 
KqiIBk93Zwf-wyA==/cn.wps.moffice_eng-LjtB5y2UMmtMJNOtyDcjTw==/split_vassonic.config.xxhdpi.apk'    
with 1 weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and
/data/app/~~WNh6GUoXLPLkd8cd_UX2ug==/com.anthropic.claude-dMbZ2i5Ass7Dw5LoT5kHJQ==/base.apk' with  
1 weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~WNh6GUo
XLPLkd8cd_UX2ug==/com.anthropic.claude-dMbZ2i5Ass7Dw5LoT5kHJQ==/split_config.arm64_v8a.apk' with   
1 weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~WNh6GUo 
XLPLkd8cd_UX2ug==/com.anthropic.claude-dMbZ2i5Ass7Dw5LoT5kHJQ==/split_config.en.apk' with 1 weak 
references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~WNh6GUo 
XLPLkd8cd_UX2ug==/com.anthropic.claude-dMbZ2i5Ass7Dw5LoT5kHJQ==/split_config.xxhdpi.apk' with 1    
weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~1u5pihW
lWI5ALG4h2GlyyA==/com.google.android.marvin.talkback-QLgvLHreLgDepAWLKVxE9g==/base.apk' with 1     
weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~1u5pihW
lWI5ALG4h2GlyyA==/com.google.android.marvin.talkback-QLgvLHreLgDepAWLKVxE9g==/split_config.arm64_v 
8a.apk' with 1 weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and
/tr_preload/operator/app/Notepad/Notepad.apk' with 1 weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and
/system_ext/app/MasterOfLanguage/MasterOfLanguage.apk' with 1 weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and
/data/app/~~ABl1OlO_ee4wgxOzQI9acA==/com.reddit.frontpage-MW2dUre-t4TiYvz2hQqrYA==/base.apk' with  
1 weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~ABl1OlO
_ee4wgxOzQI9acA==/com.reddit.frontpage-MW2dUre-t4TiYvz2hQqrYA==/split_config.arm64_v8a.apk' with   
1 weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~ABl1OlO 
_ee4wgxOzQI9acA==/com.reddit.frontpage-MW2dUre-t4TiYvz2hQqrYA==/split_config.en.apk' with 1 weak   
references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and /data/app/~~ABl1OlO
_ee4wgxOzQI9acA==/com.reddit.frontpage-MW2dUre-t4TiYvz2hQqrYA==/split_config.xxhdpi.apk' with 1    
weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object '<empty> and
/system_ext/app/AiWriting/AiWriting.apk' with 1 weak references
W/example.fyllens(10288): ApkAssets: Deleting an ApkAssets object
'/product/overlay/AiWritingOverlay-XOS.apk' with 1 weak references
D/TextSelection(10288): onUseCache cache=false
I/flutter (10288): ≡ƒô╕ [CAMERA SCREEN] Starting image processing...
I/flutter (10288):    Plant Name: Cucumber
I/flutter (10288):    Image Path: /data/user/0/com.example.fyllens/cache/scaled_477b3e02-4546-47f4 
-ab7d-390ad1c50762823039594819716348.jpg
I/flutter (10288):    User ID: 76139626-70ea-4f50-82ad-4b41f5b5da17
I/flutter (10288):    ≡ƒö¼ [CAMERA SCREEN] Calling performScan()...
I/flutter (10288): ≡ƒö¼ [SCAN PROVIDER] performScan() called
I/flutter (10288):    Parameters:
I/flutter (10288):       - Plant Name: Cucumber
I/flutter (10288):       - User ID: 76139626-70ea-4f50-82ad-4b41f5b5da17
I/flutter (10288):       - Plant ID: null
I/flutter (10288):       - Image Path: /data/user/0/com.example.fyllens/cache/scaled_477b3e02-4546
-47f4-ab7d-390ad1c50762823039594819716348.jpg
I/flutter (10288):    ≡ƒñû [SCAN PROVIDER] Step 1: Starting ML analysis...
I/flutter (10288): ≡ƒñû [ML SERVICE] analyzePlantImage() called
I/flutter (10288):    Parameters:
I/flutter (10288):       - Plant Species: Cucumber
I/flutter (10288):       - Image Path: /data/user/0/com.example.fyllens/cache/scaled_477b3e02-4546 
-47f4-ab7d-390ad1c50762823039594819716348.jpg
I/flutter (10288):       - Image Exists: true
I/flutter (10288):    ≡ƒôª [ML SERVICE] Step 1: Ensuring model is loaded...
I/flutter (10288):    ≡ƒôÑ [ML SERVICE] loadModel() called for Cucumber
I/flutter (10288):       - Model Path: assets/models/CUCUMBER/20251206_113852
I/flutter (10288):       - Loading TFLite model:
assets/models/CUCUMBER/20251206_113852/cucumber_model.tflite
I/flutter (10288):       Γ£à TFLite model loaded
I/flutter (10288):       - Loading class names:
assets/models/CUCUMBER/20251206_113852/class_names.json
I/flutter (10288):       Γ£à Class names loaded: 7 classes
I/flutter (10288):    Γ£à [ML SERVICE] Model cached successfully for Cucumber
I/flutter (10288):    Γ£à [ML SERVICE] Model loaded successfully!
I/flutter (10288):       - Number of classes: 7
I/flutter (10288):       - Classes: Anthracnose, Bacterial_Wilt, Belly_Rot, Downy_Mildew,
Gummy_Stem_Blight, Healthy, Pythium_Fruit_Rot
I/flutter (10288):      [ML SERVICE] Step 2: Preprocessing image...
I/flutter (10288):          - Reading image bytes...
I/flutter (10288):          - Image size: 227871 bytes
I/flutter (10288):          - Decoding image...
I/flutter (10288):          - Original dimensions: 768x1024
I/flutter (10288):          - Resizing to 224x224...
I/flutter (10288):          - Converting to normalized 4D array...
I/flutter (10288):          Γ£à Preprocessing complete
I/flutter (10288):    Γ£à [ML SERVICE] Image preprocessed to 224x224
I/flutter (10288):    ≡ƒö¼ [ML SERVICE] Step 3: Running inference...
I/flutter (10288):       - Output Shape: [1, 7]
I/PowerHalMgrImpl(10288): hdl:138811, pid:10288 
I/flutter (10288):    Γ£à [ML SERVICE] Inference completed!
I/flutter (10288):       - Raw Probabilities:
I/flutter (10288):          Anthracnose: 0.06%
I/flutter (10288):          Bacterial_Wilt: 1.64%
I/flutter (10288):          Belly_Rot: 3.53%
I/flutter (10288):          Downy_Mildew: 0.46%
I/flutter (10288):          Gummy_Stem_Blight: 4.61%
I/flutter (10288):          Healthy: 87.64%
I/flutter (10288):          Pythium_Fruit_Rot: 2.06%
I/flutter (10288):    ≡ƒôè [ML SERVICE] Step 4: Processing results...
I/flutter (10288):       - Predicted Class: Healthy
I/flutter (10288):       - Confidence: 87.64%
I/flutter (10288):       - Is Healthy: true
I/flutter (10288):       - Confidence Threshold: 60.0%
I/flutter (10288):    ≡ƒÄë [ML SERVICE] analyzePlantImage() completed successfully!
I/flutter (10288):    Γ£à [SCAN PROVIDER] ML Analysis completed!
I/flutter (10288):       - Deficiency: Healthy
I/flutter (10288):       - Confidence: 0.8763647675514221
I/flutter (10288):       - Is Healthy: true
I/flutter (10288):    Γÿü∩╕Å  [SCAN PROVIDER] Step 2: Uploading image to storage...
I/flutter (10288):       - Bucket: scan-images
I/flutter (10288):       - Path: 76139626-70ea-4f50-82ad-4b41f5b5da17/1765474002586.jpg
I/flutter (10288):    Γ£à [SCAN PROVIDER] Image uploaded successfully!
I/flutter (10288):       - Image URL: https://ujqgmyqsmwlbbdcchnxy.supabase.co/storage/v1/object/p 
ublic/scan-images/76139626-70ea-4f50-82ad-4b41f5b5da17/1765474002586.jpg
I/flutter (10288):    ≡ƒÅÑ [SCAN PROVIDER] Health Status: HEALTHY
I/flutter (10288):    ≡ƒîƒ [SCAN PROVIDER] Step 3: Generating enhanced care info with Gemini AI... 
I/flutter (10288): ≡ƒîƒ [GEMINI AI] Generating enhanced care info...
I/flutter (10288):    Plant: Cucumber
I/flutter (10288):    Status: Healthy
I/flutter (10288):    Health: Healthy
I/flutter (10288):    Confidence: 87.64%
I/flutter (10288): ≡ƒñû [GEMINI AI] Initializing Gemini AI service...
I/flutter (10288):    Γ£à [GEMINI AI] API key loaded from environment
I/flutter (10288):    Γ£à [GEMINI AI] Gemini AI service initialized successfully
I/flutter (10288):    ≡ƒô¥ [GEMINI AI] Sending care prompt to Gemini API...
I/flutter (10288):    ≡ƒÜ¿ [GEMINI AI] Error generating deficiency info: You exceeded your 
current quota, please check your plan and billing details. For more information on this error,     
head to: https://ai.google.dev/gemini-api/docs/rate-limits. To monitor your current usage, head    
to: https://ai.dev/usage?tab=rate-limit.
I/flutter (10288): * Quota exceeded for metric:
generativelanguage.googleapis.com/generate_content_free_tier_requests, limit: 20, model:
gemini-2.5-flash-lite
I/flutter (10288): Please retry in 50.203087261s.
I/flutter (10288):    Stack Trace: #0      parseGenerateContentResponse
(package:google_generative_ai/src/api.dart:582:54)
I/flutter (10288): <asynchronous suspension>
I/flutter (10288): #1      GeminiAIService.generateDeficiencyInfo
(package:fyllens/services/gemini_ai_service.dart:185:24)
I/flutter (10288): <asynchronous suspension>
I/flutter (10288): #2      ScanProvider.performScan
(package:fyllens/providers/scan_provider.dart:83:22)
I/flutter (10288): <asynchronous suspension>
I/flutter (10288): #3      _CameraScreenState._processImage 
(package:fyllens/screens/scan/camera_screen.dart:118:23)
I/flutter (10288): <asynchronous suspension>
I/flutter (10288):    Γä╣∩╕Å  [GEMINI AI] Using fallback care information
I/flutter (10288):    Γ£à [SCAN PROVIDER] Gemini AI care info generated successfully!
I/flutter (10288):       - Care Tips: 3
I/flutter (10288):       - Preventive Care: 3
I/flutter (10288):       - Growth Optimization: 3
I/flutter (10288):    ≡ƒÆ╛ [SCAN PROVIDER] Step 4: Saving scan result to database...
I/flutter (10288):       - Scan Data: {user_id: 76139626-70ea-4f50-82ad-4b41f5b5da17, plant_id: 
null, plant_name: Cucumber, image_url: https://ujqgmyqsmwlbbdcchnxy.supabase.co/storage/v1/object/ 
public/scan-images/76139626-70ea-4f50-82ad-4b41f5b5da17/1765474002586.jpg, deficiency_detected:    
Healthy, confidence: 0.8763647675514221, recommendations: Your plant looks healthy! Continue your  
current care routine., severity: null, symptoms: null, gemini_treatments: null, prevention_tips:   
null, care_tips: ["Maintain regular watering schedule for Cucumber","Ensure adequate sunlight      
exposure","Apply balanced fertilizer as needed"], preventive_care: ["Monitor for early signs of    
stress or deficiency","Maintain proper soil conditions and drainage","Practice good plant hygiene  
and sanitation"], growth_optimization: ["Optimize nutrient levels for better growth","Consider 
pruning for improved air circulation","Monitor and adjust care based on plant response"],
created_at: 2025-12-12T01:26:43.927452}
I/flutter (10288):    Γ£à [SCAN PROVIDER] Database insert successful!
I/flutter (10288):       - Result: {id: 44c6d7cf-1100-486d-9eec-e25f383f3dac, user_id:
76139626-70ea-4f50-82ad-4b41f5b5da17, plant_id: null, plant_name: Cucumber, image_url: https://ujq 
gmyqsmwlbbdcchnxy.supabase.co/storage/v1/object/public/scan-images/76139626-70ea-4f50-82ad-4b41f5b 
5da17/1765474002586.jpg, deficiency_detected: Healthy, confidence: 0.876, recommendations: Your    
plant looks healthy! Continue your current care routine., created_at:
2025-12-12T01:26:43.927452+00:00, severity: null, symptoms: null, gemini_treatments: null,
prevention_tips: null, care_tips: ["Maintain regular watering schedule for Cucumber","Ensure       
adequate sunlight exposure","Apply balanced fertilizer as needed"], preventive_care: ["Monitor     
for early signs of stress or deficiency","Maintain proper soil conditions and drainage","Practice  
good plant hygiene and sanitation"], growth_optimization: ["Optimize nutrient levels for better    
growth","Consider pruning for improved air circulation","Monitor and adjust care based on plant    
response"]}
I/flutter (10288):    ≡ƒôª [SCAN PROVIDER] Step 5: Creating ScanResult object...
I/flutter (10288):    Γ£à [SCAN PROVIDER] ScanResult created successfully!
I/flutter (10288):       - Scan ID: 44c6d7cf-1100-486d-9eec-e25f383f3dac
I/flutter (10288):       - Deficiency: Healthy
I/flutter (10288):    ≡ƒÄë [SCAN PROVIDER] performScan() completed successfully!
I/flutter (10288):    ≡ƒôè [CAMERA SCREEN] performScan() result: true
I/flutter (10288):    Γ£à [CAMERA SCREEN] Scan successful! Navigating to results...
I/flutter (10288): ≡ƒ¢ú∩╕Å  [APP ROUTER] /home route builder called
I/flutter (10288):    Full URI: /home
I/flutter (10288):    Query parameters: {}
I/flutter (10288):    tab parameter: null
I/flutter (10288):    initialTab parsed: 0
I/flutter (10288): Γ£à [APP ROUTER] Creating MainScreen with initialTab=0
I/flutter (10288): ≡ƒöä [MAIN SCREEN] didUpdateWidget() called
I/flutter (10288):    oldWidget.initialTab: 0
I/flutter (10288):    widget.initialTab: 0
I/flutter (10288): Γä╣∩╕Å  [MAIN SCREEN] initialTab unchanged, no update needed
W/WindowOnBackDispatcher(10288): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(10288): Set 'android:enableOnBackInvokedCallback="true"' in the
application manifest.
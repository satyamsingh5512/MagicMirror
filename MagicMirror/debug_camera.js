// Debug script to test camera in MagicMirror context
// Add this to browser console when MagicMirror is running

console.log("=== Camera Debug Script ===");

// Check if video element exists
const video = document.getElementById("camera-feed");
console.log("Video element found:", !!video);

if (video) {
    console.log("Video element details:", {
        id: video.id,
        width: video.width,
        height: video.height,
        autoplay: video.autoplay,
        muted: video.muted
    });
}

// Check MediaDevices support
console.log("MediaDevices support:", {
    available: !!navigator.mediaDevices,
    getUserMedia: !!(navigator.mediaDevices && navigator.mediaDevices.getUserMedia)
});

// Check HTTPS
console.log("Protocol:", location.protocol);
console.log("Is HTTPS:", location.protocol === 'https:');

// Test camera access
async function testCamera() {
    try {
        console.log("Testing camera access...");
        
        const stream = await navigator.mediaDevices.getUserMedia({
            video: {
                width: { ideal: 320 },
                height: { ideal: 240 },
                facingMode: 'user'
            },
            audio: false
        });
        
        console.log("Camera stream obtained:", stream);
        console.log("Video tracks:", stream.getVideoTracks());
        
        if (video) {
            video.srcObject = stream;
            await video.play();
            console.log("Video playing successfully");
        }
        
        return stream;
        
    } catch (error) {
        console.error("Camera test failed:", error);
        return null;
    }
}

// Run test
testCamera().then(stream => {
    if (stream) {
        console.log("✅ Camera test successful");
        
        // Stop after 5 seconds
        setTimeout(() => {
            stream.getTracks().forEach(track => track.stop());
            console.log("Camera stopped");
        }, 5000);
    } else {
        console.log("❌ Camera test failed");
    }
});

// Check for any existing camera streams
console.log("Existing video elements:", document.querySelectorAll('video'));
console.log("Elements with camera-feed ID:", document.querySelectorAll('#camera-feed'));
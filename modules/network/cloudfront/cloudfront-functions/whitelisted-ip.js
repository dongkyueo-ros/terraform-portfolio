function handler(event) {
    // NOTE: This example function is for a viewer request event trigger. 
    // Choose viewer request for event trigger when you associate this function with a distribution. 
    const request = event.request;
    const clientIP = event.viewer.ip;
    
    const WHITELISTED_IP = [
        '121.133.247.250',
        '210.90.186.162',
    ];
    const shouldAllowIP = WHITELISTED_IP.includes(clientIP);

    if (shouldAllowIP) {
        // Allow the original request to pass through
        return request;
    } else {
        var response = {
            statusCode: 404,
        }
        return response;
    }
}
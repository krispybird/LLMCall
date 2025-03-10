/*
IAT 806 - making API calls with ChatGPT
This uses the HTTPRequests for Processing library by runemadsen
The library is found at https://github.com/runemadsen/HTTP-Requests-for-Processing

It takes a hardcoded prompt, and makes an API call to OpenAI's ChatGPT to return an answer
Note that API calls in ChatGPT are not free. Check the tutorial slides for a list
of other GPT models you can use
*/

import http.requests.*;
import processing.data.JSONObject;

//You will need to enter an API key
// OpenAI endpoint for GPT-3
String apiKey = "";  // Replace with your actual API key
String endpoint = "https://api.openai.com/v1/chat/completions";  


void setup() {
  size (800, 800);
  background (255);
  textSize(20);  // Set text size
  textAlign(LEFT, TOP);  // Align text to the top-left corner
  fill(0);  // Set text color to black
  
  String prompt = "Generate a poem about cheese with a title"; // Example prompt
  String response = getChatGptResponse(prompt);
  text(response, 50, 50);  // Start drawing text at (50, 50)
  
  //println(response);  // Print the response from the ChatGPT model
}

//A function where we make the API call using the HTTP request library
String getChatGptResponse(String prompt) {
  // Create a JSON object for the request body
  JSONObject requestBody = new JSONObject();
  
  // Construct the messages as per OpenAI's ChatGPT API format
  JSONObject message = new JSONObject();
  message.setString("role", "user");
  message.setString("content", prompt);
  
  // Add the model and messages to the request body
  requestBody.setString("model", "gpt-3.5-turbo");  // Replace with the desired model
  requestBody.setJSONArray("messages", new JSONArray().setJSONObject(0,message));
  
  // Set up the HTTP request to OpenAI API
  PostRequest request = new PostRequest(endpoint);
  request.addData(requestBody.toString());
  request.addHeader("Authorization", "Bearer " + apiKey);
  request.addHeader("Content-Type", "application/json");
  
  // Send the POST request with the JSON body
  request.send();
  
  //Return the parsed response from the function parseGPTResponse();
  println(request.getContent());
  return parseGPTResponse(request.getContent());
  
} 
 
  
// Processing the JSON response from ChatGPT  
String parseGPTResponse(String responseBody) {
  
  //We check if responseBody is a valid json string
  //parseJSONObject parses a string and returns a JSONObject
  
  if (responseBody != null && responseBody.length() > 0) { 
    JSONObject json = parseJSONObject(responseBody);
    String chatResponse = json.getJSONArray("choices")
      .getJSONObject(0).getJSONObject("message").getString("content");
    return chatResponse;
  } 
  
  else {
    return "Invalid JSON string.";
  }
}

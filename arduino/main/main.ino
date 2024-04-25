#include <ESP8266WiFi.h>

const char* ssid = "netis_11BD83";
const char* password = "password";


void setup() {
  Serial.begin(115200);
  delay(10);
  
  // Connect to WiFi
  WiFi.begin(ssid, password);
  Serial.println("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi connected");

}

void loop() {
  // put your main code here, to run repeatedly:

  Serial.println("Hello");
  delay(1000);
}

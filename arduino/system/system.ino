#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <Servo.h>

// WiFi settings
const char* ssid = "TP-Link_C1D0";
const char* password = "81713264";

// MQTT broker settings
const char* mqtt_server = "test.mosquitto.org";
const int mqtt_port = 1883;
const char* mqtt_username = "rw";
const char* mqtt_password = "SMARTKEY@123";
const char* door_topic_control = "door/control";
// const char* knock_topic_control = "knock/setup";
// const char* passcode_topic_control = "passcode/setup";
const char* door_topic_status = "door/status";

WiFiClient espClient;
PubSubClient client(espClient); 

Servo servo;
const int servoPin = D1;

void setup() {
  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
  servo.attach(servoPin);
  pinMode(D4, OUTPUT);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  publishDoorStatus("opened");
  delay(2000);
  publishDoorStatus("closed");
  delay(2000);
}

void callback(char* topic, byte* payload, unsigned int length) {
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  
  if (strcmp(topic, door_topic_control) == 0) {
    if (message.equals("open")) {
      servo.write(180);
      digitalWrite(D4, HIGH);
      publishDoorStatus("opened");
    } else if (message.equals("close")) {
      servo.write(0);
      digitalWrite(D4, HIGH);
      publishDoorStatus("closed");
    }
  }
}

void publishDoorStatus(String doorStatus) {
  // Publish the door status to the MQTT topic
  if (client.publish(door_topic_status, doorStatus.c_str())) {
    Serial.println("Publish successful!");
  } else {
    Serial.println("Publish failed :(");
  }
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (client.connect("SmartKeyESP8266Client")) {
      Serial.println("connected");
      client.subscribe(door_topic_control);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
}

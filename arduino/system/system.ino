#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <Servo.h>

const char* ssid = "TP-Link_C1D0";
const char* password = "81713264";

const char* mqtt_server = "test.mosquitto.org";
const int mqtt_port = 1883;
const char* door_topic_control = "arduino1door/control";
// const char* knock_topic_control = "arduino1knock/setup";
// const char* passcode_topic_control = "arduino1passcode/setup";

const char* door_topic_status = "arduino1door/status";

WiFiClient espClient;
PubSubClient client(espClient); 

Servo servo;
const int servoPin = D4;
#define lock D1
#define bell D2
#define bellButton D3

void setup() {
  Serial.begin(115200);

  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
  
  servo.attach(servoPin);
  pinMode(lock, OUTPUT);
  pinMode(bell, OUTPUT);
  pinMode(bellButton, INPUT_PULLUP);
  
  closeDoor();
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  if (digitalRead(bellButton) == LOW) {
    ringBell();
  }
}

void ringBell() {
  tone(bell, 1500, 700);
}

void openDoor() {
  digitalWrite(lock, HIGH);
  servo.write(180);
  digitalWrite(D4, HIGH);
  publishDoorStatus("opened");
  Serial.println("Door opened");
  tone(bell, 2500, 400);
  delay(100);
  tone(bell, 4500, 500);
}

void closeDoor() {
  digitalWrite(lock, LOW);
  servo.write(0);
  digitalWrite(D4, LOW);
  publishDoorStatus("closed");
  Serial.println("Door closed");
  tone(bell, 200, 400);
}

void publishDoorStatus(String doorStatus) {
  if (client.publish(door_topic_status, doorStatus.c_str())) {
    Serial.println("Publish door status successful!");
  } else {
    Serial.println("Publish door status failed :(");
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  
  if (strcmp(topic, door_topic_control) == 0) {
    if (message.equals("open")) {
      openDoor();
    } else if (message.equals("close")) {
      closeDoor();
    }
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

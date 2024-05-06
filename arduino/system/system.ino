#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <Servo.h>

const char* ssid = "TP-Link_C1D0";
const char* password = "81713264";

const char* mqtt_server = "test.mosquitto.org";
const int mqtt_port = 1883;
const char* door_control_topic = "arduino1door/control";
// const char* knock_control_topic = "arduino1knock/setup";
// const char* passcode_control_topic = "arduino1passcode/setup";

const char* door_status_topic = "arduino1door/status";

WiFiClient espClient;
PubSubClient client(espClient); 

Servo servo;
const int servoPin = D4;
#define flashLed D0
#define lock D1
#define bell D2
#define bellButton D3
#define openDoorButton D5
#define closeDoorButton D6

void setup() {
  Serial.begin(115200);

  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
  
  servo.attach(servoPin);
  pinMode(flashLed, OUTPUT);
  pinMode(lock, OUTPUT);
  pinMode(bell, OUTPUT);
  pinMode(bellButton, INPUT_PULLUP);
  pinMode(openDoorButton, INPUT_PULLUP);
  pinMode(closeDoorButton, INPUT_PULLUP);
  
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

  if (digitalRead(openDoorButton) == LOW) {
    openDoor();
  }

  if (digitalRead(closeDoorButton) == LOW) {
    closeDoor();
  }
}

void ringBell() {
  tone(bell, 1500, 700);
}

void openDoor() {
  digitalWrite(lock, HIGH);
  servo.write(180);
  digitalWrite(flashLed, LOW);
  publishDoorStatus("opened");
  Serial.println("Door opened");
  tone(bell, 2500, 400);
  delay(100);
  tone(bell, 4500, 500);
}

void closeDoor() {
  digitalWrite(lock, LOW);
  servo.write(0);
  digitalWrite(flashLed, HIGH);
  publishDoorStatus("closed");
  Serial.println("Door closed");
  tone(bell, 200, 400);
}

void publishDoorStatus(String doorStatus) {
  if (client.publish(door_status_topic, doorStatus.c_str())) {
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
  
  if (strcmp(topic, door_control_topic) == 0) {
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
      client.subscribe(door_control_topic);
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

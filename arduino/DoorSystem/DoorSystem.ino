#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <Servo.h>
#include <Adafruit_Fingerprint.h>

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
#define knockCheckButton D0
#define knockSensor A0

bool isOpened = false;
int knockInputTime = 12000;
int knockSensitivity = 75;
String knockPattern = "11011011";

SoftwareSerial mySerial(D7, D8);
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&mySerial);

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
  pinMode(knockCheckButton, INPUT_PULLUP);
  pinMode(knockSensor, INPUT);
  
  setupFingerprintSensor();
  closeDoor();
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  getFingerprintID();
  if(digitalRead(knockCheckButton) == LOW && !isOpened) {
    checkKnock();
  }

  if (digitalRead(bellButton) == LOW) {ringBell();}
  if (digitalRead(openDoorButton) == LOW) {openDoor();}
  if (digitalRead(closeDoorButton) == LOW) {closeDoor();}
}

void ringBell() {
  tone(bell, 1500, 700);
}

void openDoor() {
  digitalWrite(lock, HIGH);
  servo.write(180);
  digitalWrite(flashLed, LOW);
  publishDoorStatus("opened");
  isOpened = true;
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
  isOpened = false;
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

void checkKnock() {
  long startTime;
  int sound;
  int i = 0;
  int knockLength = knockPattern.length();
  long inputSlots[6];
  String inputPattern = "";

  Serial.println("Start Recording...");
  startTime = millis();
  while (millis() < (startTime + knockInputTime)) {
    sound = analogRead(knockSensor);
    if (sound > knockSensitivity) {
      Serial.println(sound);
      delay(10);
      inputSlots[i] = millis() - startTime;
      Serial.println(inputSlots[i]);
      i++;
      if (i >= 6)
        break;
    }
  }
  Serial.println("Stop");

  inputPattern.concat("1");
  for (int j = 0; j < 5; j++) {
    if (inputSlots[j + 1] - inputSlots[j] < 1000)
      inputPattern.concat("1");
    else
      inputPattern.concat("01");
  }
  delay(100);
  Serial.print(inputPattern);

  if (inputPattern == knockPattern) {
    Serial.println("Valid knock!");
    openDoor();
  } else {
    Serial.println("Invalid knock :(");
  }
}

void setupFingerprintSensor() {
  finger.begin(57600);
  delay(5);
  if (finger.verifyPassword()) {
    Serial.println("Found fingerprint sensor!");
  }
  else {
    Serial.println("Did not find fingerprint sensor :(");
    while (1) { delay(1); }
  }
  finger.getTemplateCount();
  Serial.print("Sensor contains "); Serial.print(finger.templateCount); Serial.println(" templates");
}

int getFingerprintID() {
  uint8_t p = finger.getImage();
  if (p != FINGERPRINT_OK)  return -1;

  p = finger.image2Tz();
  if (p != FINGERPRINT_OK)  return -1;

  p = finger.fingerFastSearch();
  if (p != FINGERPRINT_OK)  return -1;

  openDoor();
  
  Serial.print("Found ID #"); Serial.print(finger.fingerID); 
  Serial.print(" with confidence of "); Serial.println(finger.confidence);
  return finger.fingerID; 
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

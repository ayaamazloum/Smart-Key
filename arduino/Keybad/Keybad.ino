#include <Keypad.h>
#include <Password.h>

Password password = Password( "AB123CD" );

const byte ROWS = 4;
const byte COLS = 4;

char keys[ROWS][COLS] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};

byte rowPins[ROWS] = {5, 4, 3, 2};
byte colPins[COLS] = {9, 8, 7, 6};

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

bool isOpened = false;
bool keypadTesting = false;

void setup() {
  Serial.begin(115200);
  keypad.addEventListener(keypadEvent);
  Serial.println("Keypad is listening...");
}

void loop() {
  keypad.getKey();
}

void keypadEvent(KeypadEvent eKey) {
  switch(keypad.getState()) {
  case PRESSED:
    Serial.print("Entered: ");
    Serial.println(eKey);
    delay(10);
    switch(eKey) {
      case '*':
        if(isOpened) {
          Serial.println("The door is already opened, no need to check!");
          break;
        }
        keypadTesting = true;
        password.reset();
        delay(1);
        break;
        
      case '#':
        if(keypadTesting) {
          if(password.evaluate()) {
            Serial.println("Valid password!");
            // openDoor();
          } else {
            Serial.println("Invalid password!");
          }
        }
        delay(1);
        break;
        
      default: def:
        if(keypadTesting)
          password.append(eKey);
        delay(1);
    }
  }
}

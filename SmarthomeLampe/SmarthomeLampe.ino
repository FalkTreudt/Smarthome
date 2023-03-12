#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>

const char* ssid = "Obi-WLAN-Kenobi"; // SSID des WLANs, mit dem sich ESP32 verbinden soll
const char* password = "Order_66"; // WLAN-Passwort
int bulbState = 0; // Zustand der Glühbirne (0 = aus, 1 = an)

WebServer server(8080);

void handleRoot() {
  server.send(200, "text/plain", String(bulbState));
}

void handleState() {
  if (server.method() == HTTP_POST) {
    String stateStr = server.arg("plain");
    if (stateStr == "1") {
      bulbState = 1;
    } else {
      bulbState = 0;
    }
  }
  server.send(200, "text/plain", String(bulbState));
}

void setup() {
  Serial.begin(115200);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  server.on("/", handleRoot);
  server.on("/state", handleState);

  server.begin();

  pinMode(2,OUTPUT);
}

void loop() {
  server.handleClient();
  if (bulbState == 1) {
    digitalWrite(2,LOW);
    Serial.println("Bulb is ON");
  } else {
    digitalWrite(2,HIGH);
    Serial.println("Bulb is OFF");
  }
  delay(1000);
}
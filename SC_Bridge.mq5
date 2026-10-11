//+------------------------------------------------------------------+
//|                                                    SC_Bridge.mq5 |
//|                                  Copyright 2026, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int db;
// 2 prices because sometimes tick doesnt work because it never instantiates
// the second price is the fallback 1st is current tick
MqlTick priceInfo[2];

struct COrder {
  int id;
  string sybol;
  float sl;
  float tp;
  float entry;
  float safeEntry;
  float trig;
  int mode;
  long date;
};

class CSetup {
private:
  double m_priceSL;
  double m_priceTP;
  double m_priceTRIG;
  double m_priceENTRY;
  double m_boxP1;
  double m_boxP2;
  double m_boxT1;
  double m_boxT2;

public:
  CSetup::CSetup(void) {}
};

class CGui {
private:
  string m_status;
  string m_button_fetch; // clicking this will populate a setup
  int m_chartId;
  bool m_button_state;
  color m_button_BGClr;

public:
  void CGui::CGui() {
    m_button_fetch = "fetch button";
    m_status = "muoy bien";
    m_chartId = 0;
    m_button_state = 1;
    m_button_BGClr = clrThistle;
    ObjectCreate(m_chartId, m_button_fetch, OBJ_BUTTON, 0, 0, 0);
    if (ObjectFind(m_chartId, m_button_fetch) == m_chartId) {
      ObjectSetInteger(m_chartId, m_button_fetch, OBJPROP_XSIZE, 90);
      ObjectSetInteger(m_chartId, m_button_fetch, OBJPROP_YSIZE, 30);
      ObjectSetInteger(m_chartId, m_button_fetch, OBJPROP_CORNER,
                       CORNER_LEFT_LOWER);
      ObjectSetInteger(m_chartId, m_button_fetch, OBJPROP_YDISTANCE, 50);
      ObjectSetString(m_chartId, m_button_fetch, OBJPROP_TEXT, "GET SETUP");
      ObjectSetInteger(m_chartId, m_button_fetch, OBJPROP_FONTSIZE, 8);
      ObjectSetString(m_chartId, m_button_fetch, OBJPROP_FONT,
                      "Lucidia Console");
      ObjectSetInteger(m_chartId, m_button_fetch, OBJPROP_BGCOLOR,
                       m_button_BGClr);
      ChartRedraw();
    } else
      Print("CANT FIND OBJECT", GetLastError());
  }
  void CGui::setButtonState(bool state) {
    m_button_state = state;
    ObjectSetInteger(ChartID(), m_button_fetch, OBJPROP_STATE, state);
  }
  bool CGui::getButtonState() { return (m_button_state); }
  void CGui::setBGClr(color colour) {
    m_button_BGClr = colour;
    ObjectSetInteger(ChartID(), m_button_fetch, OBJPROP_BGCOLOR,
                     m_button_BGClr);
  }
};

CGui gui; // Global GUI Variable

int OnInit() {
  EventSetTimer(10); // create Timer
  // setup db
  string dbName = "DB_sc-bridge.sqlite";
  db = DatabaseOpen(dbName, DATABASE_OPEN_READWRITE);
  if (db == INVALID_HANDLE) {
    Print("DB: ", dbName, " open failed with code ", GetLastError());
    return ("failed to open db");
  }

  return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
  //--- destroy timer
  EventKillTimer();
  DatabaseClose(db);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
  //---
  SymbolInfoTick(ChartSymbol(), priceInfo[0]);
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {
  Print(GetLastError());
  SymbolInfoTick(ChartSymbol(), priceInfo[1]);
  ArrayPrint(priceInfo);

  datetime t1 = iTime(NULL, 0, 0);
  datetime t2 = iTime(NULL, 0, 20);
  double p1 = iClose(NULL, 0, 0);
  double p2 = iClose(NULL, 0, 20);

  Comment("i love my bbc(big booty caucasian)");

  ObjectCreate(0, "test recky", OBJ_RECTANGLE, 0, t1, p1, t2, p2);

  // DatabasePrint(db, "SELECT * from TEST_ORDERS", 0);
  //---
}
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade() {
  //---
}
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result) {
  //---
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int32_t id, const long &lparam, const double &dparam,
                  const string &sparam) {

  if (id == CHARTEVENT_OBJECT_CLICK) {
    gui.setButtonState(0);
    Print(gui.getButtonState());
    gui.setBGClr(clrCadetBlue);
    // Print(ObjectGetInteger(ChartID(),sparam,OBJPROP_STATE));
    ChartRedraw();
  };
  //---
}
//+------------------------------------------------------------------+

//+-----------------------------------------------------------------+
//|                                                    SC_Bridge.mq5 |
//|                                  Copyright 2026, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

// 2 prices because sometimes tick doesnt work because it never instantiates
// the second price is the fallback 1st is current tick
MqlTick priceInfo[2];

struct SSetupParams {
   int m_id;
   string m_symbol;
   double m_priceSL;
   double m_priceTP;
   double m_priceENTRY;
   double m_priceSAFE_ENTRY;
   double m_priceTRIG;
   int m_mode;
   long m_date;

   void SSetupParams(void) {};
   void SSetupParams(string symbol, double sl, double tp, double entry, int id,
                     int mode, double trig, double sEntry, long date)
       : m_symbol(symbol), m_priceSL(sl), m_priceENTRY(entry), m_id(id),
         m_mode(mode), m_priceTRIG(trig), m_priceSAFE_ENTRY(sEntry),
         m_date(date) {};
};

class CSetup {
   SSetupParams m_params;
   double m_boxP1;
   double m_boxP2;
   double m_boxT1;
   double m_boxT2;
   int db;
   string dbName;

 public:
   void CSetup() {
      dbName = "DB_sc-bridge.sqlite";
      db = DatabaseOpen(dbName, DATABASE_OPEN_READWRITE);
      if (db == INVALID_HANDLE) {
         Alert("DB: ", dbName, " open failed with code ", GetLastError());
         ResetLastError();
      }
      int request = DatabasePrepare(db, "SELECT * from TEST_ORDERS");
      // loop just for reference: the loop terminates when the thing becomes 0,
      //  this info might be useful later. TODO: change to while loop
      for (int i = 0; DatabaseReadBind(request, m_params); i++) {
         Print(m_params.m_id, ",", m_params.m_mode);
      };
      DatabaseFinalize(request);
      if (GetLastError() == 5126) {
         ResetLastError();
         // this is just an error to say DatabaseReadBind cant find anymore
         // stuff
      }

      DatabaseClose(db);
   };
};

class CShape {
 protected:
 public:
   long m_chartId;
   string m_name;
   void CShape(void) { m_chartId = ChartID(); };
   void CShape(string name) {};
   void CShape(string name, int id) : m_name(name), m_chartId(ChartID()) {};
   long test() { return m_chartId; }
};

class CBtn : CShape {
   int m_sizeX;
   int m_sizeY;
   ENUM_BASE_CORNER m_corner;
   int m_distanceX;
   int m_distanceY;
   string m_text;
   int m_fontSize;
   string m_font;
   color m_colourBG;

 public:
   bool m_state;
   void CBtn() {

   };

   void CBtn(string name, ENUM_BASE_CORNER corner, int distX, int distY,
             string text)
       : CShape(name, ChartID()), m_distanceX(distX), m_distanceY(distY),
         m_text(text), m_corner(corner) {
      m_sizeX = 90;
      m_sizeY = 30;
      m_fontSize = 8;
      m_font = "Lucidia Console";
      m_colourBG = clrThistle;
      m_state = 1;
   };
   void draw() {
      ObjectCreate(m_chartId, m_name, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(m_chartId, m_name, OBJPROP_XSIZE, m_sizeX);
      ObjectSetInteger(m_chartId, m_name, OBJPROP_YSIZE, m_sizeY);
      ObjectSetInteger(m_chartId, m_name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
      ObjectSetInteger(m_chartId, m_name, OBJPROP_YDISTANCE, m_distanceY);
      ObjectSetInteger(m_chartId, m_name, OBJPROP_XDISTANCE, m_distanceX);
      ObjectSetString(m_chartId, m_name, OBJPROP_TEXT, m_text);
      ObjectSetInteger(m_chartId, m_name, OBJPROP_FONTSIZE, m_fontSize);
      ObjectSetString(m_chartId, m_name, OBJPROP_FONT, m_font);
      ObjectSetInteger(m_chartId, m_name, OBJPROP_BGCOLOR, m_colourBG);
      ChartRedraw();
   };
   bool getButtonState() { return (m_state); };
};
// class CHline : CDrawing {
//  public:
// void Drawing() {};
// };

class CGui {
 public:
   void CGui() {
      CBtn button1("CONNECT SC", CORNER_LEFT_LOWER, 10, 50, "CONNECT SC");
      Print("CGUI up and running");
      // Print("State", button1.getButtonState());
      button1.draw();
   };
   void setBGClr(string name, color colour) {
      ObjectSetInteger(ChartID(), name, OBJPROP_BGCOLOR, colour);
   }
};

CGui gui; // Global GUI Variable

int OnInit() {
   EventSetTimer(10); // create Timer
   // setup db

   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   //--- destroy timer
   EventKillTimer();
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
   ResetLastError();
   // SymbolInfoTick(ChartSymbol(), priceInfo[1]);
   // ArrayPrint(priceInfo);

   datetime t1 = iTime(NULL, 0, 0);
   datetime t2 = iTime(NULL, 0, 20);
   double p1 = iClose(NULL, 0, 0);
   double p2 = iClose(NULL, 0, 20);

   Comment("i love my bbc(big booty caucasian)");

   // ObjectCreate(0, "test recky", OBJ_RECTANGLE, 0, t1, p1, t2, p2);

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
      // gui.setButtonState(0);
      //  Print(gui.getButtonState());
      gui.setBGClr("but1", clrCadetBlue);
      //  Print(ObjectGetInteger(ChartID(),sparam,OBJPROP_STATE));
      CSetup latestSetup;

      ChartRedraw();
   };
   //---
}
//+------------------------------------------------------------------+

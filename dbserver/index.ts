import { Database } from "bun:sqlite";
import { randomInt } from "node:crypto";

//use .db instead of .sqlite because its easily recognized by mt5
const db = new Database("../db2.db");

class Order {
  id!: number;
  symbol!: string;
  sl!: number;
  tp!: number;
  entry!: number;
  trig!: number;
}


// CREATING TABLE
const qNewTable = db.query(`create table if not exists open_orders(
          id number,
          symbol string,
          sl number,
          tp number,
          entry number,
          trig number
        );`
);
const createTable = qNewTable.run();
if (createTable.changes === 0) {
  console.log("READY");
} else {
  console.log("Created Table");
}

// DUMBY DATA
const order = new Order;
const keys: (keyof Order)[] = ["id", "symbol", "sl", "tp", "entry", "trig"];
keys.forEach((key) => {
  if (key === "symbol") {
    order[key] = "AUDJPY";
  } else {
    order[key] = randomInt(3);
  }
});
//console.log(order);

// ADD ORDER
const qInsertOrder = db.query(`insert into open_orders (
  id,symbol,sl,tp,entry,trig)
  values(
    ?1,?2,?3,?4,?5,?6
  );`);

const addOrder = qInsertOrder.run(
  order.id,
  order.symbol,
  order.sl,
  order.tp,
  order.entry,
  order.trig
);

if (addOrder.changes === 1) {
  console.log("order added successfully")
}





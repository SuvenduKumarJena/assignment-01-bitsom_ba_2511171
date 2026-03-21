// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    "_id": "elec_1",
    "name": "Premium Laptop",
    "category": "Electronics",
    "price": 85000,
    "stock_quantity": 40,
    "specs": {
      "ram_gb": 16,
      "storage_gb": 512,
      "warranty_months": 12
    },
    "compatible_os": [
      "Windows", 
      "Linux"
    ]
  },
  {
    "_id": "cloth_1",
    "name": "Plain White T-Shirt",
    "category": "Clothing",
    "price": 300,
    "stock_quantity": 150,
    "attributes": {
      "size": "M",
      "material": "100% Cotton"
    },
    "care_instructions": [
      "Hand wash only", 
      "Do not iron on print"
    ]
  },
  {
    "_id": "groc_1",
    "name": "Loaf of Brown Bread",
    "category": "Groceries",
    "price": 45,
    "stock_quantity": 30,
    "expiry_date": "2024-11-20T00:00:00Z",
    "nutritional_info": {
      "calories_per_slice": 70,
      "protein_grams": 3
    },
    "ingredients": [
      "Whole wheat flour", 
      "Water", 
      "Yeast"
    ]
  }
]);

// OP2: find() — retrieve all Electronics products with price > 20000
console.log(
  db.products.find({ 
    category: "Electronics", 
    price: { $gt: 20000 } 
  }).toArray()
);

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
console.log(
  db.products.find({ 
    category: "Groceries", 
    expiry_date: { $lt: "2025-01-01T00:00:00Z" } 
  }).toArray()
);

// OP4: updateOne() — add a "discount_percent" field to a specific product
db.products.updateOne(
  { _id: "cloth_1" }, 
  { $set: { discount_percent: 15 } }
);

// OP5: createIndex() — create an index on category field and explain why
db.products.createIndex({ category: 1 });
/* EXPLANATION: I created an index on the 'category' field because users will 
   search and filter products by category a lot (like clicking on 'Electronics'). 
   Without an index, MongoDB has to search through every single product one by one. 
   With the index, it can find the right category instantly, making the app much faster.
*/
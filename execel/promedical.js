const xlsx = require('xlsx');
const fs = require('fs');
const path = require('path');

// Path to the .xls file
const filePath = path.join(__dirname, 'MEDOC.xlsx');

// Read the file into a workbook
const workbook = xlsx.readFile(filePath);

// Get the first sheet name
const sheetName = workbook.SheetNames[0];

// Get the first sheet
const sheet = workbook.Sheets[sheetName];

// Convert the sheet to JSON
const data = xlsx.utils.sheet_to_json(sheet);
let query= "INSERT INTO medicament( name, code, state, created_at, updated_at, price_nornal, price_ib, qte, qte_seil, categorie_medicament_id) VALUES "
data.forEach((medicament)=>{
    let name = medicament.name.replace("\n"," ");
    name = name.replace("'","''")
    name =  name.trim()
    name =  name + " - " + medicament.code.trim()
    let code = name.replace(/[^a-zA-Z0-9 ]/gi,"").replace(/ /gi,"_").toLowerCase()
    query += `('${name}' , '${code}', 1, '2024-10-14 22:45:04','2024-10-14 22:45:04', ${medicament.price || 0} ,${medicament.price || 0} ,${medicament.quantity || 0} , 5, 1 ) ,` ;
})
query = query.substring(0,query.length -1) + ";"
console.log(query)


 fs.writeFile("sql.sql", query,function () {
     
 });
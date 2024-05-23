const xlsx = require('xlsx');
const fs = require('fs');
const path = require('path');

// Path to the .xls file
const filePath = path.join(__dirname, 'sophia.xlsx');

// Read the file into a workbook
const workbook = xlsx.readFile(filePath);

// Get the first sheet name
const sheetName = workbook.SheetNames[0];

// Get the first sheet
const sheet = workbook.Sheets[sheetName];

// Convert the sheet to JSON
const data = xlsx.utils.sheet_to_json(sheet);
const unslugify = (text) => {
    return text
        .replace(/([A-Z])/g, ' $1') // Insert space before capital letters
        .replace(/_/g, ' ') // Replace underscores with spaces
        .replace(/\b\w/g, char => char.toUpperCase()) // Capitalize the first letter of each word
        .trim(); // Remove leading and trailing spaces
};
const slugify = (text) => {
    console.log(`TO SLUG ${text}`)
    return text.toLowerCase().replace(/\s+/g, '_');
};
const escapeSingleQuotes = (text) => {
    return text.replace(/'/g, "''");
};
const currentDate = new Date().toISOString().slice(0, 19).replace('T', ' '); // Format as YYYY-MM-DD HH:MM:SS
// Log the data
console.log(data);
const categories = [...new Set(data.map((line)=> Object.values(line)[1]))];
const types_services = [...new Set(data.map((line)=> Object.values(line)[2]))];
const services = data.map((line)=> {
    return {
        "Categorie": Object.values(line)[1],
        "typeService": Object.values(line)[2],
        "code": Object.values(line)[3],
    }
});

let queries1 = "INSERT INTO categories (label, code, created_at, updated_at) VALUES\n";
let queries2 = "INSERT INTO type_services (label, code, created_at, updated_at) VALUES\n";
let queries3 = "INSERT INTO services (label, code, category_id,type_service_id, created_at, updated_at) VALUES\n";

const categoriesChunk = categories.map(category => {
    const label = unslugify(category);
    const code = (category);
    return `('${label}', '${code}', '${currentDate}', '${currentDate}')`;
});
const typesServicesChunk = types_services.map(typeService => {
    const label = unslugify(typeService);
    const code = (typeService);
    return `('${label}', '${code}', '${currentDate}', '${currentDate}')`;
});
const servicesChunk = services.map(service => {
    console.log(service)
    const label =  unslugify(service.code);
    const code = (service.code);
   let  categorySubRequest =` (SELECT id FROM categories where code = '${service.Categorie})'`;
   let  typeServiceSubRequest = ` (SELECT id FROM type_services where code = '${service.typeService}')`;
    return `('${label}', '${code}',${categorySubRequest},${typeServiceSubRequest}, '${currentDate}', '${currentDate}')`;
});
//console.log(services)
queries1 += categoriesChunk.join(",\n") + ";";
queries2 += typesServicesChunk.join(",\n") + ";";
queries3 += servicesChunk.join(",\n") + ";";



// Optionally, write the JSON data to a file
 const jsonOutputPath = path.join(__dirname, 'output.sql');
 fs.writeFileSync(jsonOutputPath, `${queries1} \n\n\n ${queries2} \n\n\n ${queries3} `, 'utf8');
//
// console.log(`Data extracted to ${jsonOutputPath}`);

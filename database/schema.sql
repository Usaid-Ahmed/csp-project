
CREATE DATABASE IF NOT EXISTS civisphere_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE civisphere_db;

-- 1. USERS TABLE
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'citizen',
    preferred_language VARCHAR(30) DEFAULT 'English',
    theme VARCHAR(20) DEFAULT 'light',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. LOCATIONS TABLE
CREATE TABLE IF NOT EXISTS locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(100),
    description TEXT,
    address TEXT,
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. SERVICES TABLE
CREATE TABLE IF NOT EXISTS services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(100),
    description TEXT,
    department VARCHAR(150),
    contact_number VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. COMPLAINTS TABLE
CREATE TABLE IF NOT EXISTS complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tracking_id VARCHAR(50) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    subject VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100),
    location VARCHAR(255),
    status VARCHAR(30) DEFAULT 'Pending',
    admin_remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. COMPLAINT HISTORY TABLE
CREATE TABLE IF NOT EXISTS complaint_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    status VARCHAR(30) NOT NULL,
    remarks TEXT,
    updated_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id),
    FOREIGN KEY (updated_by) REFERENCES users(id)
);

-- 6. COMPLAINT ATTACHMENTS TABLE
CREATE TABLE IF NOT EXISTS complaint_attachments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id)
);

-- 7. BLOOD DONORS TABLE
CREATE TABLE IF NOT EXISTS blood_donors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    full_name VARCHAR(150) NOT NULL,
    blood_group VARCHAR(5) NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(100),
    address TEXT,
    available BOOLEAN DEFAULT TRUE,
    consent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 8. CONTACTS TABLE
CREATE TABLE IF NOT EXISTS contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    department VARCHAR(150),
    phone VARCHAR(20),
    email VARCHAR(150),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 10. FEEDBACK TABLE
CREATE TABLE IF NOT EXISTS feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    subject VARCHAR(200),
    message TEXT NOT NULL,
    rating INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 11. CHATBOT FAQ TABLE
CREATE TABLE IF NOT EXISTS chatbot_faq (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. CHATBOT LOGS TABLE
CREATE TABLE IF NOT EXISTS chatbot_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    question TEXT NOT NULL,
    response TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- DEFAULT CITIZEN SERVICES
INSERT INTO services (name, category, description)
SELECT 'Water Supply Services', 'Utilities', 'Water supply related services'
WHERE NOT EXISTS (
    SELECT 1 FROM services WHERE name = 'Water Supply Services'
);

INSERT INTO services (name, category, description)
SELECT 'Electricity', 'Utilities', 'Electricity related services'
WHERE NOT EXISTS (
    SELECT 1 FROM services WHERE name = 'Electricity'
);

INSERT INTO services (name, category, description)
SELECT 'Sanitation', 'Public Services', 'Sanitation and cleanliness services'
WHERE NOT EXISTS (
    SELECT 1 FROM services WHERE name = 'Sanitation'
);

INSERT INTO services (name, category, description)
SELECT 'Road Maintenance', 'Public Services', 'Road repair and maintenance services'
WHERE NOT EXISTS (
    SELECT 1 FROM services WHERE name = 'Road Maintenance'
);

INSERT INTO services (name, category, description)
SELECT 'Street Light', 'Public Services', 'Street light maintenance services'
WHERE NOT EXISTS (
    SELECT 1 FROM services WHERE name = 'Street Light'
);

INSERT INTO services (name, category, description)
SELECT 'Birth and Death Registration', 'Government Services', 'Birth and death registration services'
WHERE NOT EXISTS (
    SELECT 1 FROM services WHERE name = 'Birth and Death Registration'
);

-- ============================================================
-- MediSpel / MediHub Full Schema + Seed Data
-- One-shot: paste into Netlify SQL Editor and hit Ctrl+Enter
-- ============================================================

CREATE TABLE IF NOT EXISTS patients (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    username VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    id_number VARCHAR(50),
    dob DATE,
    gender VARCHAR(10),
    address TEXT,
    postal_code VARCHAR(20),
    blood_type VARCHAR(5),
    allergies TEXT,
    medical_aid VARCHAR(255),
    medical_aid_number VARCHAR(100),
    chronic_conditions TEXT,
    current_medications TEXT,
    medical_history TEXT,
    family_history TEXT,
    emergency_contact_name VARCHAR(200),
    emergency_contact_phone VARCHAR(50),
    emergency_contact_relation VARCHAR(100),
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS doctors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    username VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    specialization VARCHAR(200),
    license_number VARCHAR(100),
    practice_number VARCHAR(100),
    certificate_number VARCHAR(100),
    hpcsa_registration VARCHAR(100),
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS nurses (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    specialization VARCHAR(200),
    license_number VARCHAR(100),
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS admins (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    username VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    role VARCHAR(50) DEFAULT 'Admin',
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS clinics (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(255),
    type VARCHAR(50),
    status VARCHAR(20),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS hospitals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(255),
    beds INTEGER,
    type VARCHAR(50),
    status VARCHAR(20),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS patients_doctors (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id INTEGER NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    assigned_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(patient_id, doctor_id)
);

CREATE TABLE IF NOT EXISTS appointments (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE SET NULL,
    patient_name VARCHAR(200),
    doctor_id INTEGER REFERENCES doctors(id) ON DELETE SET NULL,
    doctor_name VARCHAR(200),
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'scheduled',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(appointment_date);
CREATE INDEX IF NOT EXISTS idx_appointments_patient ON appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON appointments(status);

CREATE TABLE IF NOT EXISTS vitals (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,
    patient_name VARCHAR(200),
    blood_pressure VARCHAR(20),
    heart_rate INTEGER,
    temperature DECIMAL(4,1),
    oxygen_saturation INTEGER,
    notes TEXT,
    recorded_by VARCHAR(200) DEFAULT 'Nurse',
    recorded_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_vitals_patient ON vitals(patient_id);
CREATE INDEX IF NOT EXISTS idx_vitals_recorded_at ON vitals(recorded_at);

CREATE TABLE IF NOT EXISTS medications (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,
    patient_name VARCHAR(200),
    medication_name VARCHAR(200) NOT NULL,
    dosage VARCHAR(100),
    administered_by VARCHAR(200),
    notes TEXT,
    administered_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_medications_patient ON medications(patient_id);

CREATE TABLE IF NOT EXISTS medical_codes (
    id SERIAL PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    description TEXT,
    code_type VARCHAR(50) DEFAULT 'ICD-10',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_medical_codes_code ON medical_codes(code);
CREATE INDEX IF NOT EXISTS idx_medical_codes_type ON medical_codes(code_type);

CREATE TABLE IF NOT EXISTS doctor_schedules (
    id SERIAL PRIMARY KEY,
    doctor_id INTEGER NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    doctor_name VARCHAR(200),
    day_of_week VARCHAR(15) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

CREATE INDEX IF NOT EXISTS idx_schedules_doctor ON doctor_schedules(doctor_id);

CREATE TABLE IF NOT EXISTS payments (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE SET NULL,
    patient_name VARCHAR(200),
    amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(50),
    reference VARCHAR(200),
    medical_aid VARCHAR(255),
    payment_date TIMESTAMPTZ DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'pending'
);

CREATE INDEX IF NOT EXISTS idx_payments_patient ON payments(patient_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);

CREATE TABLE IF NOT EXISTS expenses (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    category VARCHAR(50),
    payment_method VARCHAR(50),
    expense_date TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_expenses_category ON expenses(category);
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(expense_date);

CREATE TABLE IF NOT EXISTS claims (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE SET NULL,
    patient_name VARCHAR(200),
    doctor_id INTEGER REFERENCES doctors(id) ON DELETE SET NULL,
    doctor_name VARCHAR(200),
    medical_aid VARCHAR(255),
    member_number VARCHAR(100),
    amount DECIMAL(12,2) NOT NULL,
    service_date DATE,
    status VARCHAR(20) DEFAULT 'draft',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_claims_patient ON claims(patient_id);
CREATE INDEX IF NOT EXISTS idx_claims_doctor ON claims(doctor_id);
CREATE INDEX IF NOT EXISTS idx_claims_status ON claims(status);

CREATE TABLE IF NOT EXISTS invoices (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE SET NULL,
    patient_name VARCHAR(200),
    doctor_name VARCHAR(200),
    description TEXT,
    amount DECIMAL(12,2) NOT NULL,
    tax DECIMAL(5,2) DEFAULT 0,
    total DECIMAL(12,2) GENERATED ALWAYS AS (amount + (amount * tax / 100)) STORED,
    due_date DATE,
    status VARCHAR(20) DEFAULT 'unpaid',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_invoices_patient ON invoices(patient_id);
CREATE INDEX IF NOT EXISTS idx_invoices_status ON invoices(status);

CREATE TABLE IF NOT EXISTS chat_messages (
    id SERIAL PRIMARY KEY,
    sender_id INTEGER,
    sender_role VARCHAR(50),
    message TEXT NOT NULL,
    is_from_me BOOLEAN DEFAULT TRUE,
    sent_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_chat_sent_at ON chat_messages(sent_at);

CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    user_role VARCHAR(50),
    action TEXT NOT NULL,
    performed_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_performed_at ON audit_logs(performed_at);

-- ============================================================
-- SEED DATA
-- ============================================================

INSERT INTO patients (first_name, last_name, username, password, email, phone, id_number, dob, gender, address, postal_code, blood_type, allergies, medical_aid, medical_aid_number, chronic_conditions, current_medications, medical_history, family_history, emergency_contact_name, emergency_contact_phone, emergency_contact_relation, status, created_at) VALUES
('John', 'Smith', 'Patient1', 'Patient@123', 'john.smith@email.com', '082 123 4567', '8503155012089', '1985-03-15', 'Male', '123 Main St, Johannesburg, GP', '2000', 'O+', 'Penicillin', 'Discovery Health', 'DH123456', 'Hypertension, Type 2 Diabetes', 'Metformin 500mg, Lisinopril 10mg', 'Appendectomy 2015', 'Father - Heart Disease', 'Jane Smith', '082 111 2222', 'Wife', 'pending', NOW()),
('Emily', 'Johnson', 'Patient2', 'Patient@123', 'emily.j@email.com', '083 234 5678', '9007220023098', '1990-07-22', 'Female', '456 Oak Ave, Cape Town, WC', '8000', 'A+', 'None', 'Momentum', 'MM789012', 'Asthma', 'Salbutamol inhaler', 'Tonsillectomy 2005', 'Mother - Asthma, Grandmother - Breast Cancer', 'Robert Johnson', '083 333 4444', 'Father', 'approved', NOW());

INSERT INTO doctors (first_name, last_name, username, password, email, phone, specialization, license_number, practice_number, status, created_at) VALUES
('Sarah', 'Wilson', 'Doc1', 'Doc@1234', 'sarah.w@medihub.com', '011 123 4567', 'Cardiology', 'MD12345', 'PR67890', 'approved', NOW()),
('James', 'Miller', 'Doc2', 'Doc@1234', 'jmiller@medihub.com', '021 234 5678', 'Neurology', 'MD12346', 'PR67891', 'pending', NOW());

INSERT INTO nurses (first_name, last_name, email, phone, specialization, license_number, status, created_at) VALUES
('Lisa', 'Brown', 'lisa.b@medihub.com', '010 987 6543', 'General Nursing', 'RN45678', 'approved', NOW()),
('Michael', 'Davis', 'mdavis@medihub.com', '021 876 5432', 'Paediatric Nursing', 'RN45679', 'pending', NOW());

INSERT INTO admins (first_name, last_name, username, password, email, phone, role, status, created_at) VALUES
('Kumalop', 'Admin', 'Kumalop', 'Paul12345', 'kumalop@medihub.com', '010 123 4567', 'Super Admin', 'active', NOW()),
('Mathunywa', 'K', 'MathunywaK', 'Admin@1234', 'mathunywa@medihub.com', '010 234 5678', 'Admin', 'active', NOW()),
('Micheals', 'N', 'MichealsN', 'Admin@1234', 'micheals@medihub.com', '010 345 6789', 'Admin', 'active', NOW());

INSERT INTO medical_codes (code, description, code_type) VALUES
('A00', 'Cholera', 'ICD-10'),
('A09', 'Infectious gastroenteritis', 'ICD-10'),
('B20', 'HIV disease resulting in infectious diseases', 'ICD-10'),
('E10', 'Type 1 diabetes mellitus', 'ICD-10'),
('E11', 'Type 2 diabetes mellitus', 'ICD-10'),
('E78', 'Hyperlipidaemia', 'ICD-10'),
('I10', 'Essential (primary) hypertension', 'ICD-10'),
('I48', 'Atrial fibrillation', 'ICD-10'),
('J45', 'Asthma', 'ICD-10'),
('J15', 'Bacterial pneumonia', 'ICD-10'),
('M54', 'Dorsalgia (back pain)', 'ICD-10'),
('N39', 'Urinary tract infection', 'ICD-10'),
('R51', 'Headache', 'ICD-10'),
('R11', 'Nausea and vomiting', 'ICD-10'),
('Z00', 'General medical examination', 'ICD-10')
ON CONFLICT (code) DO NOTHING;

INSERT INTO doctor_schedules (doctor_id, doctor_name, day_of_week, start_time, end_time, is_available) VALUES
(1, 'Dr. Sarah Wilson', 'Monday', '09:00', '17:00', true),
(1, 'Dr. Sarah Wilson', 'Tuesday', '09:00', '17:00', true),
(1, 'Dr. Sarah Wilson', 'Wednesday', '09:00', '15:00', true),
(1, 'Dr. Sarah Wilson', 'Thursday', '09:00', '17:00', true),
(1, 'Dr. Sarah Wilson', 'Friday', '09:00', '14:00', true),
(1, 'Dr. Sarah Wilson', 'Saturday', '09:00', '12:00', false),
(1, 'Dr. Sarah Wilson', 'Sunday', '00:00', '00:00', false);

INSERT INTO payments (patient_id, patient_name, amount, payment_method, reference, medical_aid, payment_date, status) VALUES
(2, 'Emily Johnson', 550.00, 'medical-aid', 'MN-2025-001', 'Momentum', NOW() - INTERVAL '7 days', 'completed'),
(2, 'Emily Johnson', 350.00, 'cash', 'CASH-001', NULL, NOW() - INTERVAL '5 days', 'completed'),
(1, 'John Smith', 800.00, 'card', 'CRD-789', NULL, NOW() - INTERVAL '3 days', 'completed'),
(2, 'Emily Johnson', 450.00, 'medical-aid', 'MN-2025-002', 'Momentum', NOW() - INTERVAL '1 day', 'pending');

INSERT INTO expenses (description, amount, category, payment_method, expense_date) VALUES
('Medical Supplies', 2500.00, 'supplies', 'eft', NOW() - INTERVAL '10 days'),
('Staff Salaries', 45000.00, 'salaries', 'eft', NOW() - INTERVAL '7 days'),
('Utilities', 3500.00, 'utilities', 'debit-order', NOW() - INTERVAL '5 days'),
('Equipment Maintenance', 1800.00, 'maintenance', 'card', NOW() - INTERVAL '2 days');

INSERT INTO claims (patient_id, patient_name, doctor_id, doctor_name, medical_aid, member_number, amount, service_date, status) VALUES
(2, 'Emily Johnson', 1, 'Dr. Sarah Wilson', 'Momentum', 'MM789012', 1200.00, NOW() - INTERVAL '14 days', 'submitted');

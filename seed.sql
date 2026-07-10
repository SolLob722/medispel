-- ============================================================
-- MediSpel / MediHub Seed Data
-- Run AFTER schema.sql
-- Usage:
--   psql "postgresql://netlifydb_owner:npg_cl3stJjUqv7O@ep-lingering-scene-ajbellc5.c-3.us-east-2.db.netlify.com/netlifydb?sslmode=require" -f seed.sql
-- ============================================================

-- Patients
INSERT INTO patients (first_name, last_name, username, password, email, phone, id_number, dob, gender, address, postal_code, blood_type, allergies, medical_aid, medical_aid_number, chronic_conditions, current_medications, medical_history, family_history, emergency_contact_name, emergency_contact_phone, emergency_contact_relation, status, created_at) VALUES
('John', 'Smith', 'Patient1', 'Patient@123', 'john.smith@email.com', '082 123 4567', '8503155012089', '1985-03-15', 'Male', '123 Main St, Johannesburg, GP', '2000', 'O+', 'Penicillin', 'Discovery Health', 'DH123456', 'Hypertension, Type 2 Diabetes', 'Metformin 500mg, Lisinopril 10mg', 'Appendectomy 2015', 'Father - Heart Disease', 'Jane Smith', '082 111 2222', 'Wife', 'pending', NOW()),
('Emily', 'Johnson', 'Patient2', 'Patient@123', 'emily.j@email.com', '083 234 5678', '9007220023098', '1990-07-22', 'Female', '456 Oak Ave, Cape Town, WC', '8000', 'A+', 'None', 'Momentum', 'MM789012', 'Asthma', 'Salbutamol inhaler', 'Tonsillectomy 2005', 'Mother - Asthma, Grandmother - Breast Cancer', 'Robert Johnson', '083 333 4444', 'Father', 'approved', NOW());

-- Doctors
INSERT INTO doctors (first_name, last_name, username, password, email, phone, specialization, license_number, practice_number, status, created_at) VALUES
('Sarah', 'Wilson', 'Doc1', 'Doc@1234', 'sarah.w@medihub.com', '011 123 4567', 'Cardiology', 'MD12345', 'PR67890', 'approved', NOW()),
('James', 'Miller', 'Doc2', 'Doc@1234', 'jmiller@medihub.com', '021 234 5678', 'Neurology', 'MD12346', 'PR67891', 'pending', NOW());

-- Nurses
INSERT INTO nurses (first_name, last_name, email, phone, specialization, license_number, status, created_at) VALUES
('Lisa', 'Brown', 'lisa.b@medihub.com', '010 987 6543', 'General Nursing', 'RN45678', 'approved', NOW()),
('Michael', 'Davis', 'mdavis@medihub.com', '021 876 5432', 'Paediatric Nursing', 'RN45679', 'pending', NOW());

-- Admins
INSERT INTO admins (first_name, last_name, username, password, email, phone, role, status, created_at) VALUES
('Kumalop', 'Admin', 'Kumalop', 'Paul12345', 'kumalop@medihub.com', '010 123 4567', 'Super Admin', 'active', NOW()),
('Mathunywa', 'K', 'MathunywaK', 'Admin@1234', 'mathunywa@medihub.com', '010 234 5678', 'Admin', 'active', NOW()),
('Micheals', 'N', 'MichealsN', 'Admin@1234', 'micheals@medihub.com', '010 345 6789', 'Admin', 'active', NOW());

-- Medical Codes (ICD-10) - included in schema.sql, uncomment if you skipped schema seed
-- INSERT INTO medical_codes (code, description, code_type) VALUES
-- ('A00', 'Cholera', 'ICD-10'),
-- ('A09', 'Diarrhoea and gastroenteritis of presumed infectious origin', 'ICD-10'),
-- ('B20', 'Human immunodeficiency virus [HIV] disease', 'ICD-10'),
-- ('C50', 'Malignant neoplasm of breast', 'ICD-10'),
-- ('D50', 'Iron deficiency anaemias', 'ICD-10'),
-- ('E11', 'Type 2 diabetes mellitus', 'ICD-10'),
-- ('E78', 'Disorders of lipoprotein metabolism and other lipidaemias', 'ICD-10'),
-- ('F32', 'Depressive episode', 'ICD-10'),
-- ('G40', 'Epilepsy', 'ICD-10'),
-- ('I10', 'Essential (primary) hypertension', 'ICD-10'),
-- ('I20', 'Angina pectoris', 'ICD-10'),
-- ('I25', 'Chronic ischaemic heart disease', 'ICD-10'),
-- ('I50', 'Heart failure', 'ICD-10'),
-- ('J00', 'Acute nasopharyngitis', 'ICD-10'),
-- ('J45', 'Asthma', 'ICD-10'),
-- ('J47', 'Chronic obstructive pulmonary disease', 'ICD-10'),
-- ('J15', 'Bacterial pneumonia, not elsewhere classified', 'ICD-10'),
-- ('K21', 'Gastro-oesophageal reflux disease', 'ICD-10'),
-- ('K29', 'Gastritis and duodenitis', 'ICD-10'),
-- ('M05', 'Rheumatoid arthritis', 'ICD-10'),
-- ('M54', 'Dorsalgia', 'ICD-10'),
-- ('M80', 'Vitamin D deficiency', 'ICD-10'),
-- ('N18', 'Chronic kidney disease', 'ICD-10'),
-- ('O00-O99', 'Pregnancy, childbirth and the puerperium', 'ICD-10'),
-- ('R05', 'Cough', 'ICD-10'),
-- ('R10', 'Abdominal and pelvic pain', 'ICD-10'),
-- ('R51', 'Headache', 'ICD-10'),
-- ('Z00', 'General adult medical examination', 'ICD-10'),
-- ('Z01', 'General medical examination', 'ICD-10'),
-- ('Z23', 'Encounter for immunization', 'ICD-10'),
-- ('Z51', 'Palliative care', 'ICD-10'),
-- ('Z71', 'Persons encountering health services for counselling', 'ICD-10'),
-- ('Z76', 'Persons encountering health services in other circumstances', 'ICD-10');

-- Doctor Schedules
INSERT INTO doctor_schedules (doctor_id, doctor_name, day_of_week, start_time, end_time, is_available) VALUES
(1, 'Dr. Sarah Wilson', 'Monday', '09:00', '17:00', true),
(1, 'Dr. Sarah Wilson', 'Tuesday', '09:00', '17:00', true),
(1, 'Dr. Sarah Wilson', 'Wednesday', '09:00', '15:00', true),
(1, 'Dr. Sarah Wilson', 'Thursday', '09:00', '17:00', true),
(1, 'Dr. Sarah Wilson', 'Friday', '09:00', '14:00', true),
(1, 'Dr. Sarah Wilson', 'Saturday', '09:00', '12:00', false),
(1, 'Dr. Sarah Wilson', 'Sunday', '00:00', '00:00', false);

-- Payments
INSERT INTO payments (patient_id, patient_name, amount, payment_method, reference, medical_aid, payment_date, status) VALUES
(2, 'Emily Johnson', 550.00, 'medical-aid', 'MN-2025-001', 'Momentum', NOW() - INTERVAL '7 days', 'completed'),
(2, 'Emily Johnson', 350.00, 'cash', 'CASH-001', NULL, NOW() - INTERVAL '5 days', 'completed'),
(1, 'John Smith', 800.00, 'card', 'CRD-789', NULL, NOW() - INTERVAL '3 days', 'completed'),
(2, 'Emily Johnson', 450.00, 'medical-aid', 'MN-2025-002', 'Momentum', NOW() - INTERVAL '1 day', 'pending');

-- Expenses
INSERT INTO expenses (description, amount, category, payment_method, expense_date) VALUES
('Medical Supplies', 2500.00, 'supplies', 'eft', NOW() - INTERVAL '10 days'),
('Staff Salaries', 45000.00, 'salaries', 'eft', NOW() - INTERVAL '7 days'),
('Utilities', 3500.00, 'utilities', 'debit-order', NOW() - INTERVAL '5 days'),
('Equipment Maintenance', 1800.00, 'maintenance', 'card', NOW() - INTERVAL '2 days');

-- Claims
INSERT INTO claims (patient_id, patient_name, doctor_id, doctor_name, medical_aid, member_number, amount, service_date, status) VALUES
(2, 'Emily Johnson', 1, 'Dr. Sarah Wilson', 'Momentum', 'MM789012', 1200.00, NOW() - INTERVAL '14 days', 'submitted');

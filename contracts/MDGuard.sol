//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MDGuard {
    // Ethereum Address of the contract owner (Personally I haven no idea what this is for)
    address public owner;

    // Number of patients in the system
    uint256 public patientCount = 0;

    // Number of clinical visits in the system
    uint256 public clinicalVisits = 0;

    // Struct to represent patient's medical record
    struct PatientData {
        // Integer ID of medical record
        uint256 recordId;

        // String for patient name
        string patientName;

        // Date of Birth
        uint256 dateOfBirth;

        // Patient sex
        string sex;

        // String array storing patient's current prescriptions
        string[] currentPrescriptions;

        // String of the healthcare insurance provider (?)
        string insuranceProvider;

        // String array storing visitIds to clinical visit data
        uint256[] clinicalVisitIds;

        // Boolean variable representing if patient wishes to share healthcare information
        bool sharable;
    }

    // Struct to represent a clinical visit
    struct ClinicalVisitData {
        // Integer ID of visit data
        uint256 patientId;

        // Date of visit
        uint256 visitDate;

        // String for patient name
        string patientName;

        // String for chief complaint, if any
        string chiefComplaint;

        // String array ordering treatment plans, if multiple
        string treatmentPlans;

        // String array ordering prescriptions, if multiple
        string prescriptions;

        // Doctor visit notes, if applicable
        string doctorNotes;
    }

    // Mapping that stores patient IDs to medical data
    mapping (uint256 => PatientData) public patientRecords;

    // Mapping that stores patient IDs to clinical visits
    mapping (uint256 => ClinicalVisitData) public idToVisit;

    // Function to initialize patient data
    function createPatientData(
        string memory _patientName,
        uint256 _dateOfBirth,
        string memory _sex,
        string memory _insuranceProvider
    ) public {
        require(bytes(_patientName).length > 0, "Patient name is required");
        require(msg.sender != address(0), "Invalid sender address");

        patientCount++;

        string[] memory _currentPrescriptions = new string[](0);

        uint256[] memory _clinicalVisitIds = new uint256[](0);

        patientRecords[patientCount] = PatientData(
            patientCount,
            _patientName,
            _dateOfBirth,
            _sex,
            _currentPrescriptions,
            _insuranceProvider,
            _clinicalVisitIds,
            false
        );
    }

    // Function to create a patient visit
    function createVisitData(
        uint256 patientId,
        string memory _patientName,
        string memory _chiefComplaint,
        string memory _treatmentPlans,
        string memory _prescriptions,
        string memory _doctorNotes
    ) public {
        require(bytes(_patientName).length > 0, "Patient name is required");
        require(msg.sender != address(0), "Invalid sender address");

        clinicalVisits++;

        idToVisit[patientId] = ClinicalVisitData(
            patientId,
            block.timestamp,
            _patientName,
            _chiefComplaint,
            _treatmentPlans,
            _prescriptions,
            _doctorNotes
        );
        patientRecords[patientId].clinicalVisitIds.push(clinicalVisits);
    }

    // Contract Constructor
    constructor() {
        owner = msg.sender;
    }

    // Contract Owner Modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Only MDGuard administrators can call this function");
        _;
    }
}
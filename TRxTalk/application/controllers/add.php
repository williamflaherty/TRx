<?php
#session_start();

class Add extends CI_Controller {

	/*
	Bug: When I pass in NULL values, they still get stored in the Picture table
*/
//sample Query: check with getting return values
//Call PatientInsertUpdate ('firstTest', 'middleTest', 'lastTest', '19880809', 'path', 'picName', @str);

	public function addPatient($firstName = NULL,
		$middleName = NULL,
		$lastName = NULL,
		$birthday = NULL,
		$profilePicturePath = NULL,
		$profilePictureName = NULL)
	{
		$page = 'basic';
		#$profilePicturePath = "~/GoogleDrive/Team\ Ecuador/Data/images/$PatID.001.jpg"; //file on server. can't do it this procedure
		$this->load->database();
		$query_str = "Call PatientInsertUpdate ('$firstName', '$middleName', '$lastName',
			'$birthday', '$profilePicturePath', '$profilePictureName', @patientId)";
		$query = $this->db->query($query_str);
		//get return value id. Keys in json as [{"@my_id":"value"}]
		$query = $this->db->query("Select @patientId");
		$ret['jsonStr'] = json_encode($query->result_array());
		$this->load->view('displayJSON/'.$page, $ret);
	}
	#$_POST['var1'] = 32;


	public function addRecord($patientId = NULL,
		$surgeryTypeId = NULL,
		$doctorId = NULL,
		$isActive = NULL,
		$hasTimeout = NULL)
	{
		$page = 'basic';
		$this->load->database();
		$query_str = "Call PatientRecordInsert($patientId, $surgeryTypeId, $doctorId, $isActive, $hasTimeout, @recordId)";
		$query = $this->db->query($query_str);
		$query = $this->db->query("Select @recordId");
		$ret['jsonStr'] = json_encode($query->result_array());
		$this->load->view('displayJSON/'.$page, $ret);
	}



}
// DROP PROCEDURE IF EXISTS `PatientRecordInsert`$$
// CREATE DEFINER=`root`@`localhost` PROCEDURE `PatientRecordInsert`(
// 	IN patientId INT,
// 	IN surgeryTypeId INT,
// 	IN doctorId INT,
// 	IN isActive INT,
// 	IN hasTimeout INT,
// 	OUT returnValue INT
// )
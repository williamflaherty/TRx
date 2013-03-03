<?php
#session_start();

class Delete extends CI_Controller {


	public function deletePatient($patientId = NULL)
	{
		$page = 'basic';
		$this->load->database();
		$query_str = "Call PatientDelete ('$patientId', @returnValue)";
		$query = $this->db->query($query_str);
		$query = $this->db->query("Select @returnValue");
		$ret['jsonStr'] = json_encode($query->result_array());
		$this->load->view('displayJSON/'.$page, $ret);
	}
	//Bug: PatientDelete doesn't return a value

}
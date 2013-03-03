<?php

class Get extends CI_Controller {

	public function patientList()
	{
		$page = 'basic';
		$this->load->database();
		$query = $this->db->query("SELECT p.ID, r.IsActive, p.FirstName, p.LastName, p.MiddleName 
									from Patient p, PatientRecord r where p.ID = r.PatientID");
		$ret['jsonStr'] = json_encode($query->result_array());
		 // $data = array(
		 			// 'str' => "This is a data string"
		 			// );
		$this->load->view('displayJSON/'.$page, $ret);
	}

	public function profileURL($patientId = NULL)
	{
		$page = 'basic';
		$this->load->database();
		$query = $this->db->query("Select Path from Picture where id = $PatientID and IsProfile = 1");
		$ret['jsonStr'] = json_encode($query->result_array());
		$this->load->view('displayJSON/'.$page, $ret);
	}

	public function numPictures($patientId = NULL)
	{
		$page = 'basic';
		$this->load->database();
		$query = $this->db->query("Select count(*) as numPictures from Picture where Id = $patientId");
		$ret['jsonStr'] = json_encode($query->result_array());
		$this->load->view('displayJSON/'.$page, $ret);
	}
}
<?php

class Get extends CI_Controller {

	public function patientList($page = 'basic')
	{
		if (! file_exists('application/views/displayJSON/'.$page.'.php'))
		{
			echo "404 message here";
		 	//show_404();
		}
		$this->load->database();
		$query = $this->db->query("SELECT p.ID, r.IsActive, p.FirstName, p.LastName, p.MiddleName 
									from Patient p, PatientRecord r where p.ID = r.PatientID");
		$ret['jsonStr'] = json_encode($query->result_array());
		 // $data = array(
		 			// 'str' => "This is a data string"
		 			// );
		$this->load->view('displayJSON/'.$page, $ret);
	}

	public function portraitURL($page = 'basic', $PatientID)
	{
		$this->load->database();
		$query = $this->db->query("Select Path from Picture where id = $PatientID");
		$ret['jsonStr'] = json_encode($query->result_array());
		$this->load->view('displayJSON/'.$page, $ret);
	}



}
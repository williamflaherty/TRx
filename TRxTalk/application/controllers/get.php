<?php

class Get extends CI_Controller {

	public function patientList($page = 'basic')
	{
		if (! file_exists('application/views/displayJSON/'.$page.'.php'))
		{
			//show error
		 	show_404();
		}
		$this->load->database();
		$query = $this->db->query("SELECT * from news");
		$ret['jsonStr'] = json_encode($query->result_array());

		 // $data = array(
		 			// 'str' => "This is a data string"
		 			// );
		$this->load->view('displayJSON/'.$page, $ret);
	}
}
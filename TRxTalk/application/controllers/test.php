<?php

class Test extends CI_Controller {

	public function view($page = 'testHTML')
	{
		if (! file_exists('application/views/htmlFiles/'.$page.'.php'))
		{
			//show error
		 	show_404();
		}
		 $data = array(
		 			'str' => "This is a data string"
		 			);
		$this->load->view('htmlFiles/'.$page, $data);
	}
}

<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * CMS Sekolahku Premium Version
 * @version    2.5.4
 * @author     Anton Sofyan | https://facebook.com/antonsofyan | 4ntonsofyan@gmail.com | 0857 5988 8922
 * @copyright  (c) 2017-2023
 * @link       https://sekolahku.web.id
 *
 * PERINGATAN :
 * 1. TIDAK DIPERKENANKAN MENGGUNAKAN CMS INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 2. TIDAK DIPERKENANKAN MEMPERJUALBELIKAN APLIKASI INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 3. TIDAK DIPERKENANKAN MENGHAPUS KODE SUMBER APLIKASI.
 */

class Login extends CI_Controller {

	/**
	 * Flags that should be used when encoding to JSON.
	 *
	 * @var int
	 */
	public const REQUIRED_FLAGS = JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_AMP | JSON_HEX_QUOT | JSON_THROW_ON_ERROR | JSON_UNESCAPED_SLASHES;
	
	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		if ($this->auth->logged_in()) return redirect('dashboard', 'refresh');
		$timezone = NULL !== $this->session->userdata('general') && isset(__session('general')['timezone']) 
			? __session('general')['timezone'] 
			: 'Asia/Jakarta';
		date_default_timezone_set($timezone);
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['page_title'] = 'Login to Our Site';
		$this->vars['ip_banned'] = $this->auth->ip_banned(get_ip_address());
		$this->vars['login_info'] = $this->vars['ip_banned'] ? 'The login page has been blocked for 10 minutes' : 'Enter your username and password to log on';
		$this->load->view('users/login', $this->vars);
	}

	/**
	 * Login verify
	 * @return Object
	 */
	public function verify() {
		if ($this->input->is_ajax_request()) {
			if ($this->validation()) {
				$email = $this->input->post('email', true);
				$password = $this->input->post('password', true);
				$ip_address = get_ip_address();
				$verify = $this->auth->verify($email, $password, $ip_address) ? 'success' : 'error';
				$this->vars['status'] = $verify;
				$this->vars['message'] = $verify == 'success' ? 'logged_in' : 'not_logged_in';
				$this->vars['ip_banned'] = $this->auth->ip_banned($ip_address);
			} else {
				$this->vars['status'] = 'error';
				$this->vars['message'] = validation_errors();
				$this->vars['ip_banned'] = FALSE;
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation() {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('email', 'Email', 'trim|required|valid_email');
		$val->set_rules('password', 'Kata Sandi', 'trim|required');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}
}

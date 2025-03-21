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

class Reset_password extends CI_Controller {

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
		$timezone = NULL !== __session('general')['timezone'] ? __session('general')['timezone'] : 'Asia/Jakarta';
		date_default_timezone_set($timezone);
		$this->load->model('m_users');
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$forgot_password_key = $this->uri->segment(2);
		$is_exists = $this->model->is_exists('forgot_password_key', $forgot_password_key, 'users');
		if ( $is_exists ) {
			$this->load->view('users/reset-password', $this->vars);
		} else {
			show_404();
		}
	}

	/**
	 * Process
	 * @return Object
	 */
	public function process() {
		if ($this->input->is_ajax_request()) {
			if ($this->validation()) {
				$forgot_password_key = $this->uri->segment(2);
				$query = $this->model->RowObject('forgot_password_key', $forgot_password_key, 'users');
				if ( is_object($query) ) {
					$request_date = new DateTime($query->forgot_password_request_date);
					$today = new DateTime(date('Y-m-d H:i:s'));
					$diff = $today->diff($request_date);
					$hours = $diff->h;
					$hours = $hours + ($diff->days * 24);
					// lebih dari 2 x 24 jam maka cancel reset passwordnya
					if ($hours > 48) {
						$this->m_users->remove_forgot_password_key($query->id);
						$this->vars['status'] = 'error';
						$this->vars['message'] = 'expired';
					} else {
						$query = $this->m_users->reset_password($query->id);
						$this->vars['status'] = $query ? 'success' : 'error';
						$this->vars['message'] = $query ? 'has_updated' : 'cannot_updated';
					}
				// Not found "forgot_password_key"
				} else {
					$this->vars['status'] = 'error';
					$this->vars['message'] = '404';
				}
			// Validation errors
			} else {
				$this->vars['status'] = 'error';
				$this->vars['message'] = validation_errors();
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
		$val->set_rules('password', 'Kata Sandi', 'trim|required|min_length[6]');
		$val->set_rules('c_password', 'Kata Sandi', 'trim|matches[password]');
		$val->set_message('min_length', '{field} harus diisi minimal 6 karakter');
		$val->set_message('required', '{field} harus diisi');
		$val->set_message('matches', '{field} kata sandi harus sama');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}
}

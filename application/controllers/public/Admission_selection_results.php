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

class Admission_selection_results extends Public_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'm_registrants',
			'm_verification_subject_scores'
		]);
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		// if isset
		$start_date = __session('admission')['announcement_start_date'];
		$end_date = __session('admission')['announcement_end_date'];
		if (NULL !== $start_date && NULL !== $end_date) {
			// If not in array, redirect
			$date_range = array_date($start_date, $end_date);
			if ( ! in_array(date('Y-m-d'), $date_range)) return redirect(base_url());
		}

		$this->vars['page_title'] = 'Hasil Seleksi Penerimaan Peserta Didik Baru Tahun '.__session('admission_year');
		$this->vars['button'] = 'Lihat Hasil Seleksi';
		$this->vars['onclick'] = 'selection_results()';
		$this->vars['content'] = 'themes/'.theme_folder().'/admission-search-form';
		$this->load->view('themes/'.theme_folder().'/index', $this->vars);
	}

	/**
	 * Selection Results
	 * @return Object
	 */
	public function selection_results() {
		if ($this->input->is_ajax_request()) {
			if (__captchaActivated()) {
				$score = get_recapture_score($this->input->post('g-recaptcha-response'));
				if ($score < 0.9) {
					$this->vars['status'] = 'recaptcha_error';
	    			$this->vars['message'] = 'Recaptcha Error!';
					$this->output
						->set_content_type('application/json', 'utf-8')
						->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
						->_display();
					exit;
				}
			}

			if ($this->validation()) {
				$registration_number = strip_tags($this->input->post('registration_number'));
				$birth_date = strip_tags($this->input->post('birth_date'));
				if (_isValidDate($birth_date) && strlen($registration_number) == 10 && ctype_digit((string) $registration_number)) {
					$query = $this->m_registrants->selection_result($registration_number, $birth_date);
					$this->vars['status'] = $query['status'];
					$this->vars['message'] = $query['message'];
					$this->vars['subject_scores'] = $this->m_verification_subject_scores->get_subject_scores($registration_number, $birth_date);
				} else {
					$this->vars['status'] = 'error';
					$this->vars['message'] = 'Format data yang anda masukan tidak benar.';
				}
			} else {
				$this->vars['status'] = 'validation_errors';
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
		$val->set_rules('registration_number', 'Nomor Pendaftaran', 'trim|required|numeric|max_length[10]|min_length[10]');
		$val->set_rules('birth_date', 'Tanggal Lahir', 'trim|required|callback_date_format_check');
		$val->set_message('required', '{field} harus diisi');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}

	/**
	 * Date Format Check
	 * @param String $date
	 * @return Boolean
	 */
	public function date_format_check($date) {
		if ( ! _isValidDate($date)) {
			 $this->form_validation->set_message('date_format_check', '{field} harus diisi dengan format YYYY-MM-DD');
			 return FALSE;
	   }
		 return TRUE;
	 }
}

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

class Print_admission_form extends Public_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model('m_registrants');
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['page_title'] = 'Cetak Formulir Penerimaan Peserta Didik Baru Tahun '.__session('admission_year');
		$this->vars['button'] = 'Cetak Formulir';
		$this->vars['onclick'] = 'print_admission_form()';
		$this->vars['content'] = 'themes/'.theme_folder().'/admission-search-form';
		$this->load->view('themes/'.theme_folder().'/index', $this->vars);
	}

	/**
	 * PDF Generated Process
	 * @access public
	 */
	public function process() {
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
					$res = $this->m_registrants->find_registrant($registration_number, $birth_date);
					if ( is_null($res) ) {
						$this->vars['status'] = 'warning';
						$this->vars['message'] = 'Data dengan tanggal lahir '.indo_date($birth_date).' dan nomor pendaftaran '.$registration_number.' tidak ditemukan.';
					} else {
						$this->vars['status'] = 'success';
						$this->vars['id'] = $res['id'];
						$this->vars['registration_number'] = $res['registration_number'];
						$this->vars['birth_date'] = $res['birth_date'];
					}
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

	/**
	  * PDF Admission Form
	  */
	  public function pdf() {
		$id = $this->uri->segment(4);
		$registration_number = $this->uri->segment(5);
		$birth_date = $this->uri->segment(6);
		if ( ! _isNaturalNumber( $id ) ) return show_404();
		$query = $this->model->RowObject('id', $id, 'users');
		if ( ! is_object($query)) return show_404();
		$res = $this->m_registrants->find_registrant($registration_number, $birth_date);
		if ( is_null($res) ) return show_404();
		if ( ! filter_var($res['is_prospective_student'], FILTER_VALIDATE_BOOLEAN))  return show_404();
		if ((int) $id !== (int) $res['id']) return show_404();
		$file_name = 'FORMULIR-PPDB-TAHUN-' . substr($registration_number ?? '', 0, 4);
		$file_name .= '-' . $res['birth_date'] . '-' . $registration_number . '.pdf';
		$this->load->library('admission');
		$this->admission->pdf($res, $file_name);
	}
}

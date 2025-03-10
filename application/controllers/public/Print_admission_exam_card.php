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

class Print_admission_exam_card extends Public_Controller {

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
		$this->vars['page_title'] = 'Cetak Kartu Ujian Penerimaan Peserta Didik Baru Tahun '.__session('admission_year');
		$this->vars['button'] = 'Cetak Kartu Ujian';
		$this->vars['onclick'] = 'print_admission_exam_card()';
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

			// Validasi tanggal pencetakan
			$print_exam_card_start_date = __session('admission')['print_exam_card_start_date'];
			$print_exam_card_end_date = __session('admission')['print_exam_card_end_date'];
			if (NULL !== $print_exam_card_start_date && NULL !== $print_exam_card_end_date) {
				$date_range = array_date($print_exam_card_start_date, $print_exam_card_end_date);
				if ( ! in_array(date('Y-m-d'), $date_range)) {
					$this->vars['status'] = 'warning';
	    			$this->vars['message'] = 'Kartu peserta ujian tes tulis dapat dicetak mulai tanggal ' . indo_date($print_exam_card_start_date) . ' sampai dengan tanggal ' . indo_date($print_exam_card_end_date);
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
						$student = $this->model->RowObject('id', _toInteger($res['id']), 'users');
						if (filter_var($student->re_registration, FILTER_VALIDATE_BOOLEAN)) {
							$this->vars['status'] = 'success';
							$this->vars['id'] = $res['id'];
							$this->vars['registration_number'] = $res['registration_number'];
							$this->vars['birth_date'] = $res['birth_date'];
						} else {
							$this->vars['status'] = 'warning';
							$this->vars['message'] = 'Anda belum melakukan pendaftaran ulang!';
						}
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
	  * PDF Exam Card
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
		$this->load->model('m_admission_exam_schedule_details');
		$schedules = $this->m_admission_exam_schedule_details->get_student_exam_schedules($id);
		if ( ! is_object($schedules)) return show_404();
		$file_name = 'kartu-peserta-ujian-penerimaan-peserta-didik-baru-tahun-' . substr($query->registration_number, 0, 4);
		$file_name .= '-' . $query->registration_number . '.pdf';
		$this->load->library('exam_cards');
		$this->exam_cards->pdf($res, $schedules, $file_name);
	}
}

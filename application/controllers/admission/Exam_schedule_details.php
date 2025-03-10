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

class Exam_schedule_details extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'm_admission_exam_schedule_details',
			'm_rooms',
			'm_admission_exam_attendances'
		]);
		$this->pk = M_admission_exam_schedule_details::$pk;
		$this->table = M_admission_exam_schedule_details::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$subject_setting_detail_id = _toInteger($this->uri->segment(4));
		if (_isNaturalNumber( $subject_setting_detail_id )) {
			$query = $this->model->RowObject($this->pk, $subject_setting_detail_id, 'admission_subject_setting_details');
			$subjects = $this->model->RowObject($this->pk, $query->subject_id, 'subjects');
			$subject_setting = $this->model->RowObject($this->pk, $query->subject_setting_id, 'admission_subject_settings');
			$academic_year = $this->model->RowObject($this->pk, $subject_setting->academic_year_id, 'academic_years');
			$admission_type = $this->model->RowObject($this->pk, $subject_setting->admission_type_id, 'options');
			if (__session('major_count') > 0 && _toInteger($subject_setting->major_id) > 0) {
				$major = $this->model->RowObject($this->pk, $subject_setting->major_id, 'majors');
			}
			$this->vars['title'] = 'Pengaturan Ujian tes Tulis';
			$sub_title = ' Tahun Pelajaran ' . $academic_year->academic_year.' Jalur ' .$admission_type->option_name;
			if (__session('major_count') > 0 && _toInteger($subject_setting->major_id) > 0) {
				$sub_title .= ' - Jurusan ' . $major->major_name;
			}
			$sub_title .= ' Mata Pelajaran '. $subjects->subject_name;
			$this->vars['sub_title'] = $sub_title;
			$this->vars['admission'] = $this->vars['admission_settings'] = $this->vars['admission_exam_schedules'] = TRUE;
			$this->vars['rooms_dropdown'] = json_encode($this->m_rooms->dropdown(), self::REQUIRED_FLAGS);
			$this->vars['content'] = 'admission/exam_schedule_details';
			$this->load->view('backend/index', $this->vars);
		} else {
			show_404();
		}
	}

	/**
	 * Pagination
	 * @return Object
	 */
	public function pagination() {
		if ($this->input->is_ajax_request()) {
			$subject_setting_detail_id = _toInteger($this->input->post('subject_setting_detail_id', true));
			$keyword = trim($this->input->post('keyword', true));
			$page_number = _toInteger($this->input->post('page_number', true));
			$limit = _toInteger($this->input->post('per_page', true));
			$offset = ($page_number * $limit);
			$query = $this->m_admission_exam_schedule_details->get_where($keyword, $subject_setting_detail_id, 'rows', $limit, $offset);
			$total_rows = $this->m_admission_exam_schedule_details->get_where($keyword, $subject_setting_detail_id);
			$total_page = $limit > 0 ? ceil(_toInteger($total_rows) / _toInteger($limit)) : 1;
			$this->vars['total_page'] = _toInteger($total_page);
			$this->vars['total_rows'] = _toInteger($total_rows);
			$this->vars['rows'] = $query->result();
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Save | Update
	 * @return Object
	 */
	public function save() {
		if ($this->input->is_ajax_request()) {
			$id = _toInteger($this->input->post('id', true));
			if ($this->validation()) {
				$dataset = $this->dataset();
				$query = $this->model->upsert($id, $this->table, $dataset);
				$this->vars['status'] = $query ? 'success' : 'error';
				$this->vars['message'] = $query ? 'Data Anda berhasil disimpan.' : 'Terjadi kesalahan dalam menyimpan data';
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
	 * Dataset
	 * @return Array
	 */
	private function dataset() {
		return [
			'subject_setting_detail_id' => _toInteger($this->input->post('subject_setting_detail_id', true)),
			'room_id' => _toInteger($this->input->post('room_id', true)),
			'exam_date' => $this->input->post('exam_date', true),
			'exam_start_time' => $this->input->post('exam_start_time', true),
			'exam_end_time' => $this->input->post('exam_end_time', true)
		];
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation() {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('room_id', 'Ruang Ujian', 'trim|is_natural_no_zero|required');
		$val->set_rules('exam_date', 'Tanggal Pelaksanaan', 'trim|required');
		$val->set_rules('exam_start_time', 'Jam Mulai', 'trim|required');
		$val->set_rules('exam_end_time', 'Jam Selesai', 'trim|required');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}

	/**
	 * Generate PDF Exam Attendances
	 */
	public function print_exam_attendances() {
		$id = $this->uri->segment(4);
		if ( ! _isNaturalNumber( $id )) return show_404();
		$header = $this->m_admission_exam_schedule_details->get_title($id);
		$students = $this->m_admission_exam_attendances->get_attendance_lists($id);
		$this->load->library('exam_attendances');
		$this->exam_attendances->pdf($header, $students);
	}
}

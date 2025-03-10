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

class Exam_attendances extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'm_admission_exam_attendances',
			'm_admission_exam_schedule_details',
			'm_admission_subject_scores'
		]);
		$this->pk = M_admission_exam_attendances::$pk;
		$this->table = M_admission_exam_attendances::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$exam_schedule_id = _toInteger($this->uri->segment(4));
		if (_isNaturalNumber( $exam_schedule_id )) {
			$query = $this->model->RowObject('id', $exam_schedule_id, 'admission_exam_schedules');
			$this->vars['title'] = 'Pengaturan Peserta Ujian Tes Tulis';
			$this->vars['query'] = $this->m_admission_exam_schedule_details->get_title($exam_schedule_id);
			$this->vars['admission'] = $this->vars['admission_settings'] = $this->vars['admission_exam_schedules'] = TRUE;
			$this->vars['content'] = 'admission/exam_attendances';
			$this->load->view('backend/index', $this->vars);
		} else {
			show_404();
		}
	}

	/**
	 * Get Prospective Students
	 * @return Object
	 */
	public function get_prospective_students() {
		if ($this->input->is_ajax_request()) {
			$exam_schedule_id = _toInteger($this->input->post('exam_schedule_id', true));
			$this->vars['students'] = [];
			if (_isNaturalNumber( $exam_schedule_id )) {
				$query = $this->model->RowObject('id', $exam_schedule_id, 'admission_exam_schedules');
				$students = $this->m_admission_exam_attendances->get_prospective_students($query->subject_setting_detail_id);
				if ($students->num_rows() > 0) {
					foreach ($students->result() as $row) {
						$this->vars['students'][] = [
							'student_id' => $row->student_id,
							'registration_number' => $row->registration_number,
							'full_name' => $row->full_name
						];
					}
				}
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Save Presences
	 * @return Object
	 */
	public function save_attendance() {
		if ($this->input->is_ajax_request()) {
			$presences = json_decode($this->input->post('presences'), true);
			$this->vars['message'] = $this->m_admission_exam_attendances->save_attendance($presences) ? 'updated':'not_updated';
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Get Attendances List
	 * @return Object
	 */
	public function get_attendance_lists() {
		if ($this->input->is_ajax_request()) {
			$exam_schedule_id = _toInteger($this->input->post('exam_schedule_id', true));
			$this->vars['students'] = [];
			if (_isNaturalNumber( $exam_schedule_id )) {
				$query = $this->m_admission_exam_attendances->get_attendance_lists($exam_schedule_id);
				if ($query->num_rows() > 0) {
					foreach ($query->result() as $row) {
						$this->vars['students'][] = [
							'id' => $row->id,
							'registration_number' => $row->registration_number,
							'full_name' => $row->full_name,
							'presence' => $row->presence
						];
					}
				}
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Save Attendance List
	 * @return Object
	 */
	public function save_attendance_lists() {
		if ($this->input->is_ajax_request()) {
			$student_ids = $this->input->post('student_ids', true);
			$exam_schedule_id = _toInteger($this->input->post('exam_schedule_id', true));
			$ids = [];
			foreach (explode(',', $student_ids) as $student_id) {
				array_push($ids, trim($student_id));
			}
			$query = $this->m_admission_exam_attendances->save_attendance_lists($ids, $exam_schedule_id);
			$this->vars['status'] = $query ? 'success' : 'error';
			$this->vars['message'] = $query ? 'Data sudah disipman' : 'Data tidak tersimpan. Kemungkinan terjadi duplikasi data atau server bermasalah, silahkan periksa kembali data Anda.';
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Delete Attendance List
	 * @return Object
	 */
	public function delete_attendance_lists() {
		if ($this->input->is_ajax_request()) {
			$ids = $this->input->post('ids', true);
			$array_ids = [];
			foreach (explode(',', $ids) as $id) {
				array_push($array_ids, trim($id));
			}
			$query = $this->m_admission_exam_attendances->delete_attendance_lists($array_ids);
			$this->vars['status'] = $query ? 'success' : 'error';
			$this->vars['message'] = $query ? 'Data sudah terhapus' : 'Data tidak terhapus.';
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}
}

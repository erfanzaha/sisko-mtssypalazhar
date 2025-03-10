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

class Meeting_attendance_report extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'm_meeting_attendences'
			, 'm_academic_years'
			, 'm_class_groups'
			, 'm_course_classes'
			, 'm_subjects'
		]);
		// Jika bukan Guru, redirect ke dashboard
		$employment_type = __session('employment_type');
		if (NULL !== $employment_type && FALSE === strpos(strtolower($employment_type), 'guru')) {
			return redirect('dashboard', 'refresh');
		}
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->load->helper('form');
		$this->vars['title'] = 'Rekap Presensi';
		$this->vars['meeting_attendance_report'] = TRUE;
		$this->vars['academic_year_dropdown'] = $this->m_academic_years->dropdown();
		$this->vars['class_group_dropdown'] = $this->m_class_groups->dropdown();
		$this->vars['subject_dropdown'] = $this->m_subjects->dropdown();
		$this->vars['content'] = 'teacher/meeting_attendance_report';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * Summary Report
	 */
	public function summary_report() {
		if ($this->input->is_ajax_request()) {
			$academic_year_id = _toInteger($this->input->post('academic_year_id', true));
			$semester = $this->input->post('semester', true);
			$class_group_id = _toInteger($this->input->post('class_group_id', true));
			$subject_id = _toInteger($this->input->post('subject_id', true));
			$start_date = substr($this->input->post('start_date', true), 0, 10);
			$end_date = substr($this->input->post('end_date', true), 0, 10);
			if (!_isValidDate($start_date)) $start_date = date('Y-m-d');
			if (!_isValidDate($end_date)) $end_date = date('Y-m-d');
			$employee_id = (int) __session('user_id');
			$course_class_id = $this->m_course_classes->find_id($academic_year_id, $semester, $class_group_id, $subject_id, $employee_id);
			$this->vars['rows'] = _isNaturalNumber( $course_class_id ) ? $this->m_meeting_attendences->get_meeting_attendance_summary_report($course_class_id, $start_date, $end_date) : [];
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Detail Report
	 */
	public function detail_report() {
		if ($this->input->is_ajax_request()) {
			$academic_year_id = _toInteger($this->input->post('academic_year_id', true));
			$semester = $this->input->post('semester', true);
			$class_group_id = _toInteger($this->input->post('class_group_id', true));
			$subject_id = _toInteger($this->input->post('subject_id', true));
			$start_date = substr($this->input->post('start_date', true), 0, 10);
			$end_date = substr($this->input->post('end_date', true), 0, 10);
			if ( ! _isValidDate($start_date)) $start_date = date('Y-m-d');
			if ( ! _isValidDate($end_date)) $end_date = date('Y-m-d');
			$employee_id = (int) __session('user_id');
			$course_class_id = $this->m_course_classes->find_id($academic_year_id, $semester, $class_group_id, $subject_id, $employee_id);
			$this->vars['dates'] = array_date($start_date, $end_date);
			$this->vars['rows'] = [];
			if ( _isNaturalNumber( $course_class_id ) ) {
				$this->vars['rows'] = $this->m_meeting_attendences->get_meeting_attendance_detail_report($course_class_id, $start_date, $end_date);
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}
}

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

class Class_meetings extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'm_course_classes',
			'm_class_meetings',
			'm_meeting_attendences'
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
		$id = _toInteger($this->uri->segment(4));
		$query = $this->model->RowObject('id', $id, 'course_classes');
		if (is_object($query) &&
			// If isset current_academic_year_id
			NULL !== __session('current_academic_year_id') &&
			// If academic_year_id is equal to current_academic_year_id
			_toInteger($query->academic_year_id) === _toInteger(__session('current_academic_year_id')) &&
			// If isset user_id
			NULL !== __session('user_id') &&
			// If user_id is equal to $query->employee_id
			_toInteger(__session('user_id')) === _toInteger($query->employee_id)
		) {
			$this->load->helper('form');
			$this->vars['title'] = 'Masuk Kelas';
			$this->vars['academic_schedules'] = TRUE;
			$this->vars['query'] = $this->m_course_classes->get_course_classes_by_id($id);
			$this->vars['content'] = 'teacher/class_meetings';
			$this->load->view('backend/index', $this->vars);
		} else {
			show_404();
		}
	}

	/**
	 * Check Class Meetings
	 */
	public function is_exists() {
		if ($this->input->is_ajax_request()) {
			$this->vars['status'] = 'error';
			$this->vars['message'] = 'ID bukan tipe angka dan/atau tanggal bukan format yang benar';
			$course_class_id = _toInteger($this->input->post('course_class_id', true));
			$date = $this->input->post('date', true);
			if ( _isNaturalNumber( $course_class_id ) && _isValidDate($date)) {
				$this->vars['is_exists'] = $this->m_class_meetings->is_exists($course_class_id, $date);
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Insert Class Meetings
	 */
	public function insert() {
		if ($this->input->is_ajax_request()) {
			$this->vars['status'] = 'error';
			$this->vars['message'] = 'ID bukan tipe angka dan/atau tanggal bukan format yang benar';
			$course_class_id = _toInteger($this->input->post('course_class_id', true));
			$date = $this->input->post('date', true);
			if ( _isNaturalNumber( $course_class_id ) && _isValidDate($date)) {
				$this->vars['status'] = $this->m_class_meetings->insert($course_class_id, $date) ? 'success' : 'error';
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Update Class Meetings
	 */
	public function update() {
		if ($this->input->is_ajax_request()) {
			$this->vars['status'] = 'error';
			$this->vars['message'] = 'ID bukan tipe angka dan/atau tanggal bukan format yang benar';
			$course_class_id = _toInteger($this->input->post('course_class_id', true));
			$date = $this->input->post('date', true);
			if ( _isNaturalNumber( $course_class_id ) && _isValidDate($date)) {
				$query = $this->m_class_meetings->update($this->dataset(), $course_class_id, $date);
				$this->vars['status'] = $query ? 'success' : 'error';
				$this->vars['method'] = 'update';
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
			'start_time' => $this->input->post('start_time') ? $this->input->post('start_time', true) : date('H:i:s'),
			'end_time' => $this->input->post('end_time') ? $this->input->post('end_time', true) : date('H:i:s'),
			'discussion' => $this->input->post('discussion') ? $this->input->post('discussion', true) : NULL
		];
	}

	/**
	 * Get Class Meetings
	 */
	public function get_class_meetings() {
		if ($this->input->is_ajax_request()) {
			$this->vars['status'] = 'error';
			$this->vars['message'] = 'ID bukan tipe angka dan/atau tanggal bukan format yang benar';
			$course_class_id = _toInteger($this->input->post('course_class_id', true));
			$date = $this->input->post('date', true);
			if ( _isNaturalNumber( $course_class_id ) && _isValidDate($date)) {
				$class_meeting = $this->m_class_meetings->get_class_meetings($course_class_id, $date);
				$this->vars['date'] = $class_meeting->date;
				$this->vars['start_time'] = $class_meeting->start_time;
				$this->vars['end_time'] = $class_meeting->end_time;
				$this->vars['discussion'] = $class_meeting->discussion;
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Print Meeting Attendance
	 */
	public function print_meeting_attendance() {
		$course_class_id = $this->uri->segment(4);
		$date = $this->uri->segment(5);
		if ( _isNaturalNumber( $course_class_id ) && _isValidDate($date)) {
			// Class Meeting
			$class_meeting = $this->m_class_meetings->get_class_meetings($course_class_id, $date);
			$params['date'] = indo_date($class_meeting->date);
			$params['time'] = $class_meeting->start_time . ' - '. $class_meeting->end_time;
			$params['discussion'] = $class_meeting->discussion;
			// Course Class
			$course_class = $this->m_course_classes->get_course_classes_by_id($course_class_id);
			$params['academic_year'] = $course_class->academic_year;
			$params['semester'] = $course_class->semester;
			$params['subject_name'] = $course_class->subject_name;
			$params['class_group'] = $course_class->class_group;
			$params['full_name'] = $course_class->full_name;
			// Get Students
			$class_meeting_id = $this->m_class_meetings->class_meeting_id($course_class_id, $date);
			$params['students'] = $this->m_meeting_attendences->get_meeting_attendences($class_meeting_id);
			// PDF File Name
			$file_name = 'laporan-data-kehadiran-siswa-';
			$file_name .= $course_class->academic_year . '-';
			$file_name .= strtolower($course_class->semester) . '-';
			$file_name .= strtolower(str_replace(' ', '-', $course_class->subject_name)).'-';
			$file_name .= strtolower(str_replace(' ', '', $course_class->class_group)).'-';
			$file_name .= $class_meeting->date;
			$file_name .=  '-' . time() . '.pdf';
			$params['file_name'] = $file_name;
			$this->load->library('meeting_attendances');
			$this->meeting_attendances->pdf($params);
		}
	}
}

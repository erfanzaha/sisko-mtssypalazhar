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

class Daily_attendance_report extends Admin_Controller {

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
		]);
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->load->helper('form');
		$this->vars['title'] = 'Rekap Presensi Per Hari';
		$this->vars['academic'] = $this->vars['student_attendance_report'] = $this->vars['daily_attendance_report'] = TRUE;
		$this->vars['academic_year_dropdown'] = $this->m_academic_years->dropdown();
		$this->vars['class_group_dropdown'] = $this->m_class_groups->dropdown();
		$this->vars['content'] = 'academic/daily_attendance_report';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * Get Daily Attendance Report
	 */
	public function get_daily_attendance_report() {
		if ($this->input->is_ajax_request()) {
			$academic_year_id = _toInteger($this->input->post('academic_year_id', true));
			$semester = $this->input->post('semester', true);
			$class_group_id = _toInteger($this->input->post('class_group_id', true));
			$start_date = substr($this->input->post('start_date', true), 0, 10);
			$end_date = substr($this->input->post('end_date', true), 0, 10);
			if (!_isValidDate($start_date)) $start_date = date('Y-m-d');
			if (!_isValidDate($end_date)) $end_date = date('Y-m-d');
			$this->vars['dates'] = array_date($start_date, $end_date);
			$this->vars['attendance'] = $this->m_meeting_attendences->get_daily_attendance_report($academic_year_id, $semester, $class_group_id, $start_date, $end_date);
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}
}

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

class Subject_teachers extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'm_subject_teachers'
			, 'm_academic_years'
			, 'm_class_groups'
			, 'm_users'
		]);
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->load->helper('form');
		$this->vars['title'] = 'Pengaturan Guru Mata Pelajaran';
		$this->vars['academic'] = $this->vars['academic_settings'] = $this->vars['subject_teachers'] = TRUE;
		$this->vars['academic_year_dropdown'] = $this->m_academic_years->dropdown();
		$this->vars['class_group_dropdown'] = $this->m_class_groups->dropdown();
		$this->vars['teachers'] = json_encode([0 => 'Unset'] + $this->m_users->dropdown('teacher'), self::REQUIRED_FLAGS);
		$this->vars['content'] = 'academic/set_subject_teachers';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * Get Subjects
	 */
	public function get_subjects() {
		if ($this->input->is_ajax_request()) {
			$academic_year_id = _toInteger($this->input->post('academic_year_id', true));
			$semester = $this->input->post('semester', true);
			$class_group_id = _toInteger($this->input->post('class_group_id', true));
			$this->vars['subjects'] = $this->m_subject_teachers->get_subjects($academic_year_id, $semester, $class_group_id);
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Save Subject Teachers
	 */
	public function save() {
		if ($this->input->is_ajax_request()) {
			$course_classes = json_decode($this->input->post('course_classes'), true);
			$query = $this->m_subject_teachers->save($course_classes);
			$this->vars['status'] = $query ? 'success' : 'error';
			$this->vars['message'] = $query ? 'Data Anda berhasil disimpan.' : 'Terjadi kesalahan dalam menyimpan data';
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}
}

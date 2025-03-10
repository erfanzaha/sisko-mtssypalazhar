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

class Course_classes extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'm_course_classes'
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
		$this->vars['title'] = 'Pengaturan Mata Pelajaran';
		$this->vars['academic'] = $this->vars['academic_settings'] = $this->vars['course_classes'] = TRUE;
		$this->vars['academic_year_dropdown'] = $this->m_academic_years->dropdown();
		$this->vars['class_group_dropdown'] = $this->m_class_groups->dropdown();
		$this->vars['content'] = 'academic/set_course_classes';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * Get Subjects
	 */
	public function get_subjects() {
		if ($this->input->is_ajax_request()) {
			$copy_data = $this->input->post('copy_data', true);
			$academic_year_id = _toInteger($this->input->post('academic_year_id', true));
			$semester = $this->input->post('semester', true);
			$class_group_id = _toInteger($this->input->post('class_group_id', true));
			$this->vars['subjects'] = $this->m_course_classes->get_subjects($copy_data, $academic_year_id, $semester, $class_group_id);
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}

	}

	/**
	 * Get Course Classes
	 */
	public function get_course_classes() {
		if ($this->input->is_ajax_request()) {
			$academic_year_id = _toInteger($this->input->post('academic_year_id', true));
			$semester = $this->input->post('semester', true);
			$class_group_id = _toInteger($this->input->post('class_group_id', true));
			$this->vars['course_classes'] = $this->m_course_classes->get_course_classes($academic_year_id, $semester, $class_group_id);
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Save to Destination Class
	 */
	public function save() {
		if ($this->input->is_ajax_request()) {
			$subject_ids = $this->input->post('subject_ids', true);
			$ids = [];
			foreach (explode(',', $subject_ids) as $subject_id) {
				array_push($ids, trim($subject_id));
			}
			$academic_year_id = _toInteger($this->input->post('academic_year_id', true));
			$semester = $this->input->post('semester', true);
			$class_group_id = _toInteger($this->input->post('class_group_id', true));
			$query = $this->m_course_classes->save($ids, $academic_year_id, $semester, $class_group_id);
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
	 * Change Is Deleted
	 */
	public function change_deleted_status() {
		if ($this->input->is_ajax_request()) {
			$ids = $this->input->post('ids', true);
			$course_class_ids = [];
			foreach (explode(',', $ids) as $id) {
				array_push($course_class_ids, _toInteger($id));
			}
			$is_deleted = $this->input->post('is_deleted', true);
			$academic_year_id = _toInteger($this->input->post('academic_year_id', true));
			$semester = $this->input->post('semester', true);
			$class_group_id = _toInteger($this->input->post('class_group_id', true));
			$query = $this->m_course_classes->change_deleted_status($course_class_ids, $academic_year_id, $semester, $class_group_id, $is_deleted);
			$this->vars['status'] = $query ? 'success' : 'error';
			$this->vars['message'] = $query ? 'Data sudah dikembalikan' : 'Data gagal dikembalikan';
			if (filter_var($is_deleted, FILTER_VALIDATE_BOOLEAN)) {
				$this->vars['message'] = $query ? 'Data sudah terhapus' : 'Data tidak terhapus';
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}
}

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

class Subject_national_exam_details extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'm_admission_subject_setting_details',
			'm_subjects'
		]);
		$this->pk = M_admission_subject_setting_details::$pk;
		$this->table = M_admission_subject_setting_details::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$subject_setting_id = $this->uri->segment(4);
		if ($subject_setting_id) {
			$query = $this->model->RowObject($this->pk, $subject_setting_id, 'admission_subject_settings');
			$academic_year = $this->model->RowObject($this->pk, $query->academic_year_id, 'academic_years');
			$admission_type = $this->model->RowObject($this->pk, $query->admission_type_id, 'options');
			if (__session('major_count') > 0 && _toInteger($query->major_id) > 0) {
				$major = $this->model->RowObject($this->pk, $query->major_id, 'majors');
			}
			$this->vars['title'] = 'Pengaturan Nilai Ujian Nasional';
			$sub_title = 'Tahun Pelajaran ' . $academic_year->academic_year.' Jalur ' .$admission_type->option_name;
			if (__session('major_count') > 0 && _toInteger($query->major_id) > 0) {
				$sub_title .= ' - '. $major->major_name;
			}
			$this->vars['sub_title'] = $sub_title;
			$this->vars['admission'] = $this->vars['admission_settings'] = $this->vars['subject_national_exam_settings'] = TRUE;
			$this->vars['subjects_dropdown'] = json_encode($this->m_subjects->dropdown(), self::REQUIRED_FLAGS);
			$this->vars['content'] = 'admission/subject_national_exam_details';
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
			$subject_setting_id = _toInteger($this->input->post('subject_setting_id', true));
			$keyword = trim($this->input->post('keyword', true));
			$page_number = _toInteger($this->input->post('page_number', true));
			$limit = _toInteger($this->input->post('per_page', true));
			$offset = ($page_number * $limit);
			$query = $this->m_admission_subject_setting_details->get_where($keyword, $subject_setting_id, 'rows', $limit, $offset);
			$total_rows = $this->m_admission_subject_setting_details->get_where($keyword, $subject_setting_id);
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
			'subject_setting_id' => _toInteger($this->input->post('subject_setting_id', true)),
			'subject_id' => _toInteger($this->input->post('subject_id', true)),
			'visibility' => $this->input->post('visibility', true)
		];
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation() {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('subject_id', 'Mata Pelajaran', 'trim|required');
		$val->set_rules('visibility', 'Tampil di Form Pendaftaran?', 'trim|required|in_list[public,private]');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}
}

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

class National_exam_scores extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->helper('form');
		$this->load->model([
			'm_majors',
			'm_academic_years',
			'm_admission_subject_scores'
		]);
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['title'] = 'Input Nilai Ujian Nasional';
		$this->vars['admission'] = $this->vars['national_exam_scores'] = TRUE;
		$this->vars['admission_year_dropdown'] = $this->m_academic_years->dropdown(true);
		$this->vars['admission_type_dropdown'] = get_options('admission_type', FALSE);
		$majors = [0 => 'Unset'];
		if (__session('major_count') > 0) {
			$majors = [0 => 'Unset'] + $this->m_majors->dropdown();
		}
		$this->vars['major_dropdown'] = $majors;
		$this->vars['content'] = 'admission/national_exam_scores';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * Get Prospective Students
	 */
	public function get_prospective_students() {
		if ($this->input->is_ajax_request()) {
			$admission_year_id = _toInteger($this->input->post('admission_year_id', true));
			$admission_type_id = _toInteger($this->input->post('admission_type_id', true));
			$major_id = _toInteger($this->input->post('major_id', true));
			$page_number = _toInteger($this->input->post('page_number', true));
			$limit = _toInteger($this->input->post('per_page', true));
			$offset = ($page_number * $limit);
			// Generate Nilai Ujian Nasional
			$this->m_admission_subject_scores->generate_subject_scores($admission_year_id, $admission_type_id, $major_id, 'national_exam');
			// Get Prospective Students
			$query = $this->m_admission_subject_scores->get_subject_scores($admission_year_id, $admission_type_id, $major_id, 'national_exam', 'rows', $limit, $offset);
			$total_rows = $this->m_admission_subject_scores->get_subject_scores($admission_year_id, $admission_type_id, $major_id, 'national_exam');
			$total_page = $limit > 0 ? ceil(_toInteger($total_rows) / _toInteger($limit)) : 1;
			$this->vars['students'] = [];
			$this->vars['total_rows'] = _toInteger($total_rows);
			$this->vars['total_page'] = _toInteger($total_page);
			if (is_object($query)) {
				foreach($query->result() as $row) {
					$this->vars['students'][] = [
						'id' => $row->id,
						'registration_number' => $row->registration_number,
						'full_name' => $row->full_name,
						'subject_name' => $row->subject_name,
						'score' => $row->score
					];
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
	 * Save Scores
	 */
	public function save() {
		if ($this->input->is_ajax_request()) {
			$scores = json_decode($this->input->post('scores'), true);
			$this->vars['message'] = $this->m_admission_subject_scores->save($scores) ? 'updated':'not_updated';
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}
}

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

class Verification_subject_scores extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model('m_verification_subject_scores');
		$this->pk = m_verification_subject_scores::$pk;
		$this->table = m_verification_subject_scores::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['title'] = 'Verifikasi Nilai';
		$this->vars['admission'] = $this->vars['verification_subject_scores'] = TRUE;
		$this->vars['content'] = 'admission/verification_subject_scores';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * Pagination
	 * @return Object
	 */
	public function pagination() {
		if ($this->input->is_ajax_request()) {
			$keyword = trim($this->input->post('keyword', true));
			$page_number = _toInteger($this->input->post('page_number', true));
			$limit = _toInteger($this->input->post('per_page', true));
			$offset = ($page_number * $limit);
			$query = $this->m_verification_subject_scores->get_where($keyword, 'rows', $limit, $offset);
			$total_rows = $this->m_verification_subject_scores->get_where($keyword);
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
			'score' => $this->input->post('score', true)
		];
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation() {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('score', 'Skor', 'trim|required|callback_score_check');
		$val->set_message('required', '{field} harus diisi');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}

	/**
	 * Callback Score Check
	 * @return Boolean
	 */
	public function score_check($str) {
		if (!preg_match('/^[0-9]+(\.[0-9]{1,2})?$/', $str)) {
			$this->form_validation->set_message('score_check', 'Format angka yang anda masukan salah');
			return FALSE;
		} else if (floatval($str) > 100) {
			$this->form_validation->set_message('score_check', 'Nilai maksimal yang harus diinput adalah 100');
			return FALSE;
		}
		return TRUE;
	}
}

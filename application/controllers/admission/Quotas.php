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

class Quotas extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'm_admission_quotas',
			'm_majors',
			'm_academic_years'
		]);
		$this->pk = M_admission_quotas::$pk;
		$this->table = M_admission_quotas::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['title'] = 'Kuota Penerimaan';
		$this->vars['admission'] = $this->vars['admission_settings'] = $this->vars['admission_quotas'] = TRUE;
		$this->vars['academic_year_dropdown'] = json_encode($this->m_academic_years->dropdown(), self::REQUIRED_FLAGS);
		$majors = [0 => 'Unset'];
		if (__session('major_count') > 0) {
			$majors = [0 => 'Unset'] + $this->m_majors->dropdown();
		}
		$this->vars['major_dropdown'] = json_encode($majors, self::REQUIRED_FLAGS);
		$this->vars['content'] = 'admission/quotas';
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
			$query = $this->m_admission_quotas->get_where($keyword, 'rows', $limit, $offset);
			$total_rows = $this->m_admission_quotas->get_where($keyword);
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
			'academic_year_id' => _toInteger($this->input->post('academic_year_id', true)),
			'admission_type_id' => _toInteger($this->input->post('admission_type_id', true)),
			'major_id' => _toInteger($this->input->post('major_id', true)) ? _toInteger($this->input->post('major_id', true)) : 0,
			'quota' => _toInteger($this->input->post('quota', true))
		];
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation() {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('academic_year_id', 'Tahun Pelajaran', 'trim|is_natural_no_zero|required');
		$val->set_rules('admission_type_id', 'Jenis Pendaftaran', 'trim|is_natural_no_zero|required');
		if (__session('major_count') > 0) {
			$val->set_rules('major_id', 'Jurusan', 'trim|required');
		}
		$val->set_rules('quota', 'Kuota Penerimaan', 'trim|is_natural_no_zero|required');
		$val->set_message('required', '{field} harus diisi');
		$val->set_message('numeric', '{field} harus diisi dengan angka');
		$val->set_message('is_natural_no_zero', '{field} harus diisi dengan angka dan tidak boleh Nol');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}
}

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

class Form_settings extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model('m_form_settings');
		$this->pk = M_form_settings::$pk;
		$this->table = M_form_settings::$table;
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['admission'] = $this->vars['admission_settings'] = $this->vars['form_settings'] = TRUE;
		$this->vars['query'] = $this->m_form_settings->get_rows();
		$this->vars['content'] = 'admission/form_settings';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * Save | Update
	 * @return Object
	 */
	public function save() {
		if ($this->input->is_ajax_request()) {
			$settings = json_decode($this->input->post('field_setting'));
			$success = 0; $error = 0;
			foreach ($settings as $values) {
				$field_setting = (array) $values;
				$id = $field_setting['id'];
				unset($field_setting['id']);
				$this->db->set('field_setting', json_encode($field_setting));
				$this->db->set('updated_by', __session('user_id'));
				$this->db->where($this->pk, $id);
				$query = $this->db->update($this->table);
				$query ? $success++ : $error++;
			}
			$this->vars['message'] = $success . ' record berhasil diperbaharui'. ($error > 0 ? ', dan '.$error . ' record gagal diperbaharui.' : '');
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars))
				->_display();
			exit;
		}
	}
}

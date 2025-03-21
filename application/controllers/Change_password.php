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

class Change_password extends Admin_Controller {

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['title'] = 'Ubah Kata Sandi';
		$this->vars['change_password'] = TRUE;
		$this->vars['content'] = 'change_password';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * Save | Update
	 * @return Object
	 */
	public function save() {
		if ($this->input->is_ajax_request()) {
			$id = _toInteger(__session('user_id'));
			if (_isNaturalNumber( $id )) {
				if ($this->validation()) {
					$query = $this->model->RowObject('id', $id, 'users');
					if (password_verify($this->input->post('current_password', true), $query->password)) {
						$dataset = $this->dataset();
						$this->vars['status'] = $this->model->update($id, 'users', $dataset) ? 'success' : 'error';
						$this->vars['message'] = $this->vars['status'] == 'success' ? 'updated' : 'not_updated';
					} else {
						$this->vars['status'] = 'error';
						$this->vars['message'] = 'not_updated';
					}
				} else {
					$this->vars['status'] = 'error';
					$this->vars['message'] = validation_errors();
				}
			} else {
				$this->vars['status'] = 'error';
				$this->vars['message'] = 'not_updated';
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
			'password' => password_hash($this->input->post('new_password', true), PASSWORD_BCRYPT, ['cost' => 12])
		];
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation() {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('current_password', 'Kata Sandi Saat Ini', 'trim|required');
		$val->set_rules('new_password', 'Kata Sandi Baru', 'trim|required');
		$val->set_rules('retype_new_password', 'Ulangi Kata Sandi Baru', 'trim|required|matches[new_password]');
		$val->set_message('required', '{field} harus diisi');
		$val->set_message('matches', 'Kata sandi tidak sama');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}
}

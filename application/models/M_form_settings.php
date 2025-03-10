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

class M_form_settings extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'field_settings';

	/**
	 * Get All Rows
	 * @return Resource
	 */
	public function get_rows() {
		$this->db->select('id, field_name, field_description, field_setting');
		return $this->db->get(self::$table);
	}

	/**
	 * Get Form Settings
	 * @return Array
	 */
	public function get_form_settings() {
		$query = $this->get_rows();
		$form = [];
		foreach ($query->result() as $row) {
			$field_setting = json_decode($row->field_setting);
			$form[$row->field_name] = [
				'admission' => $field_setting->admission,
				'admission_required' => $field_setting->admission_required
			];
		}
		return $form;
	}
}

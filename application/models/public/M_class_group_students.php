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

class M_class_group_students extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'class_group_students';
	/**
	 * Get Students
	 * @param Integer $academic_year_id
	 * @param Integer $class_group_id
	 * @return Resource
	 */
	public function get_students($academic_year_id, $class_group_id) {
		$this->db->select("
			x1.id
			, x3.nis
			, x3.nisn
			, x3.full_name
			, x3.birth_place
			, x3.birth_date
			, IF(x3.gender = 'M', 'L', 'P') AS gender
			, x3.photo
		");
		$this->db->join("class_group_settings x2", "x1.class_group_setting_id = x2.id", "LEFT");
		$this->db->join("users x3", "x1.student_id = x3.id", "LEFT");
		$this->db->where("x1.is_deleted", "false");
		$this->db->where("x2.academic_year_id", _toInteger($academic_year_id));
		$this->db->where("x2.class_group_id", _toInteger($class_group_id));
		$this->db->order_by("x3.full_name", 'ASC');
		return $this->db->get("class_group_students x1");
	}
}

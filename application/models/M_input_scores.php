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

class M_input_scores extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'class_meetings';

	/**
	 * Get class meetings by course class ID and date
	 * @param Integer $course_class_id
	 * @param String $date
	 * @return Resource
	 */
	public function get_class_meetings($course_class_id, $date) {
		// If Not Exist, then insert this
		if (! $this->is_exists($course_class_id, $date)) {
			$this->insert($course_class_id, $date);
		}
		$query = $this->db
			->where('course_class_id', _toInteger($course_class_id))
			->where('date', $date)
			->limit(1)
			->get(self::$table);
		if ($query->num_rows() === 1) {
			return $query->row();
		}
		return NULL;
	}

	/**
	 * Is Exist class meetings by course class ID and date
	 * @param Integer $course_class_id
	 * @param String $date
	 * @return Boolean
	 */
	public function is_exists($course_class_id, $date) {
		$count = $this->db
			->where('course_class_id', _toInteger($course_class_id))
			->where('date', $date)
			->count_all_results(self::$table);
		return $count > 0;
	}

	/**
	 * Insert class meetings by course class ID and date
	 * @param Integer $course_class_id
	 * @param String $date
	 * @return Boolean
	 */
	public function insert($course_class_id, $date) {
		if ( ! $this->is_exists($course_class_id, $date)) {
			$dataset = [
				'course_class_id' => _toInteger($course_class_id),
				'date' => $date,
				'start_time' => date('H:i:s'),
				'end_time' => date('H:i:s'),
				'created_by' => (int) __session('user_id')
			];
			return $this->db->insert(self::$table, $dataset);
		}
		return FALSE;
	}

	/**
	 * Insert class meetings by course class ID and date
	 * @param Array $dataset
	 * @param Integer $course_class_id
	 * @param String $date
	 * @return Boolean
	 */
	public function update($dataset, $course_class_id, $date) {
		return $this->db
			->where('course_class_id', _toInteger($course_class_id))
			->where('date', $date)
			->update(self::$table, $dataset);
	}

	/**
	 * Is Exist class meetings by course class ID and date
	 * @param Integer $course_class_id
	 * @param String $date
	 * @return Boolean
	 */
	public function class_meeting_id($course_class_id, $date) {
		$query = $this->db
			->select('id')
			->where('course_class_id', _toInteger($course_class_id))
			->where('date', $date)
			->get(self::$table);
		if ($query->num_rows() === 1) {
			$result = $query->row();
			return $result->id;
		}
		return 0;
	}
}
